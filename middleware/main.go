package main

import (
	"context"
	"encoding/base64"
	"encoding/hex"
	"errors"
	"fmt"
	"github.com/btcsuite/btcd/txscript"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
	"ord_data/db"
	"ord_data/models"
	"ord_data/utils"
	"os"
	"os/signal"
	"strings"
	"syscall"
	"time"
)

func main() {
	err := db.InitDB()
	if err != nil {
		utils.WrapErrorLog(err.Error())
		panic(err)
	}
	app := fiber.New(fiber.Config{
		AppName:       "Rocketbot ORD API",
		StrictRouting: false,
		WriteTimeout:  time.Second * 240,
		ReadTimeout:   time.Second * 240,
		IdleTimeout:   time.Second * 240,
	})
	app.Use(cors.New())

	app.Get("/ord/:tx", getTX)
	app.Get("/ping", ping)
	app.Post("/image/save", savePic)
	app.Get("/gallery", getGallery)

	go func() {
		err := app.Listen(fmt.Sprintf(":%d", 4100))
		if err != nil {
			utils.WrapErrorLog(err.Error())
			panic(err)
		}
	}()
	c := make(chan os.Signal, 1)
	signal.Notify(c, syscall.SIGTERM, syscall.SIGINT)
	utils.ReportMessage("<- Started BTC CORE API ->")
	<-c
	_, cancel := context.WithTimeout(context.Background(), time.Second*15)
	utils.ReportMessage("/// = = Shutting down = = ///")
	defer cancel()
	_ = app.Shutdown()
	os.Exit(0)
}

func getGallery(c *fiber.Ctx) error {
	type Database struct {
		OrdID  string `json:"ord_id" db:"ord_id"`
		Base64 string `json:"base64" json:"base64"`
	}
	res, err := db.ReadArrayStruct[Database]("SELECT ord_id, base64 FROM ORD")
	if err != nil {
		utils.WrapErrorLog(err.Error())
		return utils.ReportError(c, err.Error(), fiber.StatusBadRequest)
	}
	return c.Status(fiber.StatusOK).JSON(&fiber.Map{
		"gallery": res,
	})
}

func savePic(c *fiber.Ctx) error {
	type Request struct {
		Base64 string `json:"base64"`
		Name   string `json:"name"`
	}
	var req Request
	err := c.BodyParser(&req)
	if err != nil {
		utils.WrapErrorLog(err.Error())
		return utils.ReportError(c, err.Error(), fiber.StatusBadRequest)
	}
	if req.Base64 == "" {
		return utils.ReportError(c, "Bad Request", fiber.StatusBadRequest)
	}
	_, err = db.InsertSQl("INSERT INTO ORD (ord_id, base64) VALUES (?, ?)", req.Name, req.Base64)
	if err != nil {
		utils.WrapErrorLog(err.Error())
		return utils.ReportError(c, err.Error(), fiber.StatusBadRequest)
	}
	return c.Status(fiber.StatusOK).JSON(&fiber.Map{
		"message": "success",
	})
}

func ping(c *fiber.Ctx) error {
	return c.Status(fiber.StatusOK).JSON(
		fiber.Map{
			"message": "pong",
		})
}

func getTX(c *fiber.Ctx) error {
	tx := c.Params("tx")
	if len(tx) < 2 {
		return utils.ReportError(c, "tx is too short", fiber.StatusBadRequest)
	}
	//subtract 2 places from the end
	tx = tx[:len(tx)-2]
	res, err := utils.GETRequest[models.RawTX](fmt.Sprintf("https://blockstream.info/api/tx/%s", tx))
	if err != nil {
		utils.WrapErrorLog(err.Error())
		return utils.ReportError(c, err.Error(), fiber.StatusBadRequest)
	}

	r, err := getWitnessData(res.Vin[0].Witness)
	if err != nil {
		utils.WrapErrorLog(err.Error())
		return utils.ReportError(c, err.Error(), fiber.StatusBadRequest)
	}
	return c.Status(fiber.StatusOK).JSON(*r)
}

func getWitnessData(witnessData []string) (*models.ResponseJSON, error) {
	witnessBytes, err := hex.DecodeString(witnessData[1])
	if err != nil {
		return nil, err
	}

	// Parse the script
	disasm, err := txscript.DisasmString(witnessBytes)
	if err != nil {
		utils.WrapErrorLog(err.Error())
		return nil, err
	}

	// Split into operations
	ops := strings.Split(disasm, " ")
	b64 := ""
	fileType := ""
	var err2 error
	// Print the operations
	for i := 0; i < len(ops); i++ {
		op := ops[i]
		if op == "OP_IF" {
			// The next four items should be 'ord', version, MIME type, and the data
			if i+4 < len(ops) {
				// Decode the MIME type
				mimeTypeBytes, err := hex.DecodeString(ops[i+3])
				if err != nil {
					fmt.Printf("Failed to decode MIME type for operation %s: %v\n", ops[i+3], err)
					continue
				}

				mimeType := string(mimeTypeBytes)
				fmt.Printf("MIME type: %s\n", mimeType)

				// Decode the data
				var dataBytes []byte
				for j := i + 5; j < len(ops); j++ {
					op2 := ops[j]
					if op2 == "OP_ENDIF" {
						break
					}

					if op2 == "OP_PUSHDATA1" || op2 == "OP_PUSHDATA2" || op2 == "OP_PUSHDATA4" {
						j++
					}

					dataByte, err := hex.DecodeString(op2)
					if err != nil {
						fmt.Printf("Failed to decode data byte for operation %s: %v\n", op2, err)
						continue
					}

					dataBytes = append(dataBytes, dataByte...)
				}

				// Handle the data differently depending on the MIME type
				switch mimeType {
				case "text/plain;charset=utf-8":
					err2 = errors.New("not a picture")
					break
				case "image/png":
					fileType = "png"
					b64 = base64.StdEncoding.EncodeToString(dataBytes)
					break
				case "image/jpeg", "image/jpg":
					fileType = "jpg"
					b64 = base64.StdEncoding.EncodeToString(dataBytes)
					break
				case "image/webp":
					fileType = "webp"
					b64 = base64.StdEncoding.EncodeToString(dataBytes)
					break
				case "image/gif":
					fileType = "gif"
					b64 = base64.StdEncoding.EncodeToString(dataBytes)
					break
				default:
					err2 = errors.New("unknown file type")
					fmt.Printf("Data: Unknown MIME type, length %d\n", len(dataBytes))
				}

				// Skip the next four items, as we've already processed them
				i += 4
			}
		}
	}
	if err2 != nil {
		return nil, err2
	}
	rest := &fiber.Map{
		"base64":   b64,
		"filename": fmt.Sprintf("file.%s", fileType),
	}
	address := os.Getenv("SERVER_HOST")
	if address == "" {
		address = "0.0.0.0:4000"
	}
	utils.ReportMessage(fmt.Sprintf("http://%s/pic/check", address))
	r, err := utils.POSTRequest[models.ResponseJSON](fmt.Sprintf("http://%s/pic/check", address), rest)
	if err != nil {
		utils.WrapErrorLog(err.Error())
		return nil, err
	}

	if r.NsfwPic == false && r.NsfwText == false {
		r.Base64 = b64
		r.Filename = fmt.Sprintf("file.%s", fileType)
	}
	return &r, nil
}
