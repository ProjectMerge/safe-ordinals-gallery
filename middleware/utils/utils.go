package utils

import (
    "errors"
    "fmt"
    "github.com/gofiber/fiber/v2"
    "github.com/joho/godotenv"
    "io"
    "log"
    "os"
    "runtime"
    "strings"
    "sync"
)

const (
    VERSION          = "0.1.1.3"
    STATUS    string = "status"
    OK        string = "OK"
    FAIL      string = "FAIL"
    ERROR     string = "hasError"
    ServerUrl string = "184.174.35.183"
)

func InlineIF[T any](condition bool, a T, b T) T {
    if condition {
        return a
    }
    return b
}

func GetENV(key string) string {
    err := godotenv.Load(".env")
    if err != nil {
        WrapErrorLog("Error loading .env file")
    }
    return os.Getenv(key)
}

func ReturnError(err string) error {
    go logToFile(fmt.Sprintf("[ERROR] %s ", err))
    return errors.New(err)
}

var m sync.Mutex

func logToFile(message string) {
    m.Lock()
    defer m.Unlock()
    f, err := os.OpenFile("api.log", os.O_RDWR|os.O_CREATE|os.O_APPEND, 0666)
    if err != nil {
        log.Printf("error opening file: %v\n", err)
    }
    wrt := io.MultiWriter(os.Stdout, f)
    log.SetOutput(wrt)
    log.Println(message)
    log.Println("")
    _ = f.Close()
}

func WrapErrorLog(message string) {
    go logToFile(fmt.Sprintf("[ERROR] %s", message))
}

func WrapErrorLogF(message string, args ...any) {
    go logToFile(fmt.Sprintf(message, args))
}

func ReportWarning(message string) {
    if !strings.Contains(message, "tx_id_UNIQUE") {
        go logToFile(fmt.Sprintf("[WARNING] %s", message))
    }
}

func ReportError(c *fiber.Ctx, err string, statusCode int) error {
    json := fiber.Map{
        "errorMessage": err,
        STATUS:         FAIL,
        ERROR:          true,
    }
    if statusCode == 500 {
        if !strings.Contains(err, "tx_id_UNIQUE") || strings.Contains(err, "Invalid Token, idUser") {
            go logToFile(fmt.Sprintf("[WARNING] %s %s %s %s", "HTTP call failed : ", err, "  Status code: ", fmt.Sprintf("%d", statusCode)))
        }
    } else {
        go logToFile(fmt.Sprintf("[WARNING] %s %s %s %s", "HTTP call failed : ", err, "  Status code: ", fmt.Sprintf("%d", statusCode)))
    }
    return c.Status(statusCode).JSON(json)
}

func ReportMessage(message string) {
    go logToFile(fmt.Sprintf("[INFO] %s", message))
}

func GetHomeDir() string {
    if runtime.GOOS == "windows" {
        home := os.Getenv("HOMEDRIVE") + os.Getenv("HOMEPATH")
        if home == "" {
            home = os.Getenv("USERPROFILE")
        }
        return home
    } else if runtime.GOOS == "linux" {
        home := os.Getenv("XDG_CONFIG_HOME")
        if home != "" {
            return home
        }
    }
    return os.Getenv("HOME")
}

func FileExists(filePath string) bool {
    _, err := os.Stat(filePath)
    if os.IsNotExist(err) {
        return false
    }
    return true
}
