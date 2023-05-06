package db

import (
	"errors"
	"fmt"
	"github.com/jmoiron/sqlx"
	_ "github.com/mattn/go-sqlite3"
	"log"
	"net/url"
	"ord_data/utils"
	"os"
	"strconv"
)

type Client struct {
	client *sqlx.DB
}

var Database *Client

const dbName string = "./db/data.db"

const dbVersion int = 1

func InitDB() error {
	if Database != nil {
		utils.WrapErrorLog("DB already opened")
		return nil
	}
	utils.ReportMessage("DB opening")
	key := url.QueryEscape("kGMbPd3BrGJ6Htd")
	databaseName := fmt.Sprintf("%s?_pragma_key=%s&_pragma_cipher_page_size=4096", dbName, key)

	exists := false

	// if folder .config doesn't exist, create it
	if _, err := os.Stat("./.data"); os.IsNotExist(err) {
		err := os.Mkdir("./.data", 0777)
		if err != nil {
			log.Fatal(err)
		}
	}

	if _, err := os.Stat(dbName); err != nil {
		exists = false
	} else {
		exists = true
	}

	db, err := sqlx.Open("sqlite3", databaseName)

	if err != nil {
		err := os.Remove(dbName)
		if err != nil {
			utils.WrapErrorLog(err.Error())
			return err
		}
		utils.WrapErrorLog(err.Error())
		return err
	}

	if !exists {
		_ = ExecQuery(db, fmt.Sprintf("PRAGMA user_version = %d", dbVersion))
	}
	initTables(db)
	Database = &Client{db}
	return nil
}

func initTables(db *sqlx.DB) {
	createTxTable := `CREATE TABLE IF NOT EXISTS ORD (
		"id" integer NOT NULL PRIMARY KEY AUTOINCREMENT,	
		"base64" TEXT NOT NULL,
		"ord_id" TEXT NOT NULL UNIQUE		
	  );`

	err := ExecQuery(db, createTxTable)
	if err != nil {
		utils.WrapErrorLog(err.Error())
		return
	}
	err, i := GetVersion(db)
	if err != nil {
		return
	}

	switch i {
	case 0, 1:

	//	err = ExecQuery(db, "ALTER TABLE DAEMON_TABLE ADD COLUMN conf TEXT NOT NULL DEFAULT ('')")
	//	err = ExecQuery(db, "ALTER TABLE DAEMON_TABLE ADD COLUMN ip TEXT NOT NULL DEFAULT ('')")
	//	break
	//case 2:
	//	err = ExecQuery(db, "ALTER TABLE DAEMON_TABLE ADD COLUMN mn_port INT NOT NULL DEFAULT 0")
	//	break
	//case 3:
	//	err = ExecQuery(db, "ALTER TABLE DAEMON_TABLE ADD COLUMN wallet_passphrase TEXT")
	//	break
	//case 4:
	//	err = ExecQuery(db, "ALTER TABLE JWT_TABLE ADD COLUMN refreshToken TEXT")
	//	break
	//case 5:
	//	err = ExecQuery(db, "ALTER TABLE STAKING_DAEMON_TABLE ADD COLUMN ip TEXT DEFAULT ('127.0.0.1')")
	//	break
	default:
		break
	}

	err = ExecQuery(db, fmt.Sprintf("PRAGMA user_version = %d", dbVersion))

	if err != nil {
		fmt.Printf("Error while creating table token")
		fmt.Println(err.Error())
		return
	}

}

func ExecQuery(db *sqlx.DB, sql string) error {
	statementJWT, err := db.Prepare(sql) // Prepare SQL Statement
	if err != nil {
		fmt.Println(err.Error())
	}
	_, err = statementJWT.Exec()
	if err != nil {
		fmt.Printf("Error while creating table jwt")
		fmt.Println(err.Error())
		return err
	}
	_ = statementJWT.Close()
	return nil
}

func GetVersion(db *sqlx.DB) (error, int) {
	insertSQL := `
	PRAGMA
	user_version
	`
	rows := db.QueryRow(insertSQL)
	var Ver string
	err := rows.Scan(&Ver)

	if err != nil {
		return err, 0
		//log.Fatalln(err.Error())
	}

	atoi, err := strconv.Atoi(Ver)
	if err != nil {
		return err, 0
	}
	return nil, atoi
}

func ReadSql(SQL string, params ...interface{}) (*sqlx.Rows, error) {
	results, errRow := Database.client.Queryx(SQL, params...)
	if errRow != nil {
		fmt.Println(errRow.Error())
		return nil, errRow
	} else {
		return results, nil
	}
}

func ReadValue[T any](SQL string, params ...interface{}) (T, error) {
	d := make(chan T, 1)
	e := make(chan error, 1)
	go func(data chan T, err chan error) {
		var an T
		errDB := Database.client.QueryRow(SQL, params...).Scan(&an)
		if errDB != nil {
			err <- errDB
		} else {
			data <- an
		}
	}(d, e)
	select {
	case data := <-d:
		close(d)
		close(e)
		return data, nil
	case err := <-e:
		close(d)
		close(e)
		return getZero[T](), err
	}
}

func ReadValueEmpty[T any](SQL string, params ...interface{}) T {
	d := make(chan T, 1)
	e := make(chan error, 1)
	go func(data chan T, err chan error) {
		var an T
		errDB := Database.client.QueryRow(SQL, params...).Scan(&an)
		if errDB != nil {
			err <- errDB
		} else {
			data <- an
		}
	}(d, e)
	select {
	case data := <-d:
		close(d)
		close(e)
		return data
	case err := <-e:
		close(d)
		close(e)
		log.Println(err)
		return getZero[T]()
	}
}

func ReadStruct[T any](SQL string, params ...interface{}) (T, error) {
	d := make(chan T, 1)
	e := make(chan error, 1)
	go func(data chan T, err chan error) {
		rows, errDB := Database.client.Queryx(SQL, params...)
		if errDB != nil {
			_ = rows.Close()
			err <- errDB
		} else {
			var s T
			s, errDB := ParseStruct[T](rows)
			if errDB != nil {
				_ = rows.Close()
				err <- errDB
			}
			_ = rows.Close()
			data <- s
		}
	}(d, e)
	select {
	case data := <-d:
		close(d)
		close(e)
		return data, nil
	case err := <-e:
		close(d)
		close(e)
		return getZero[T](), err
	}
}

func ReadStructEmpty[T any](SQL string, params ...interface{}) T {
	d := make(chan T, 1)
	go func(data chan T) {
		rows, err := Database.client.Queryx(SQL, params...)
		if err != nil {
			utils.WrapErrorLog(err.Error())
			i := getZero[T]()
			_ = rows.Close()
			data <- i
			//return i
		} else {
			var s T
			s, err := ParseStruct[T](rows)
			if err != nil {
				utils.WrapErrorLog(err.Error())
				_ = rows.Close()
				data <- getZero[T]()
				//return getZero[T]()
			}
			_ = rows.Close()
			data <- s
		}
	}(d)
	select {
	case data := <-d:
		close(d)
		return data
	}
}

func ReadArrayStruct[T any](SQL string, params ...interface{}) ([]T, error) {
	d := make(chan []T, 1)
	e := make(chan error, 1)
	go func(data chan []T, err chan error) {
		rows, errDB := ReadSql(SQL, params...)
		if errDB != nil {
			//utils.WrapErrorLog(err.Error())
			//i := getZeroArray[T]()
			//data <- i
			err <- errDB
		} else {
			s := ParseArrayStruct[T](rows)
			if errDB != nil {
				_ = rows.Close()
				err <- errDB
			}
			_ = rows.Close()
			data <- s
		}
	}(d, e)
	select {
	case data := <-d:
		close(d)
		close(e)
		return data, nil
	case err := <-e:
		close(d)
		close(e)
		return getZeroArray[T](), err
	}
}

func ReadArray[T any](SQL string, params ...interface{}) ([]T, error) {
	d := make(chan []T, 1)
	e := make(chan error, 1)
	go func(data chan []T, err chan error) {
		i := make([]T, 0)
		rows, errDB := Database.client.Queryx(SQL, params...)
		if errDB != nil {
			utils.WrapErrorLog(errDB.Error())
			//data <- i
			err <- errDB
		} else {
			for rows.Next() {
				var s T
				if errDB := rows.Scan(&s); errDB != nil {
					//data <- i
					err <- errDB
				} else {
					i = append(i, s)
				}
			}
			_ = rows.Close()
			data <- i
		}
	}(d, e)
	select {
	case data := <-d:
		close(d)
		close(e)
		return data, nil
	case err := <-e:
		close(d)
		close(e)
		return getZeroArray[T](), err
	}
}

func ParseArrayStruct[T any](rows *sqlx.Rows) []T {
	d := make(chan []T, 1)
	e := make(chan error, 1)
	go func(data chan []T, errChan chan error) {
		var stk T
		stakeArray := make([]T, 0)
		count := 0
		for rows.Next() {
			count++
			if err := rows.StructScan(&stk); err != nil {
				utils.WrapErrorLog(err.Error())
				utils.WrapErrorLogF("err: %v\n", err)
				errChan <- err
				//return nil
			} else {
				stakeArray = append(stakeArray, stk)
			}
		}
		_ = rows.Close()
		data <- stakeArray
		//return stakeArray
	}(d, e)
	select {
	case data := <-d:
		close(d)
		close(e)
		return data
	case _ = <-e:
		close(d)
		close(e)
		return nil
	}
}

func ParseStruct[T any](rows *sqlx.Rows) (T, error) {
	d := make(chan T, 1)
	e := make(chan error, 1)
	go func(data chan T, errChan chan error) {
		var stk T
		for rows.Next() {
			if err := rows.StructScan(&stk); err != nil {
				_ = rows.Close()
				utils.WrapErrorLogF("err: %v\n", err)
				errChan <- err
			}
		}
		_ = rows.Close()
		data <- stk
	}(d, e)
	select {
	case data := <-d:
		close(d)
		close(e)
		return data, nil
	case err := <-e:
		close(d)
		close(e)
		return getZero[T](), err
	}
}

func getZero[T any]() T {
	var result T
	return result
}

func getZeroArray[T any]() []T {
	var result []T
	return result
}

func InsertSQl(SQL string, params ...interface{}) (int64, error) {
	if Database == nil {
		return 0, errors.New("database not connected")
	}
	query, errStmt := Database.client.Exec(SQL, params...)
	if errStmt != nil {
		//fmt.Printf("Can't Insert shit")
		return 0, errStmt
	}
	id, errLastID := query.LastInsertId()
	if errLastID != nil {
		return 0, errLastID
	}
	return id, nil
}

func GetSQL(SQL string, inter *struct{}, params ...interface{}) error {
	db, err := sqlx.Open("mysql", utils.GetENV("DB_CONN"))

	defer func(db *sqlx.DB) {
		_ = db.Close()
	}(db)

	err = db.Get(&inter, SQL, params...)
	if err != nil {
		return err
	}
	return nil
}
