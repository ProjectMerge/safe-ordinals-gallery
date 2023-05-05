package models

type ResponseJSON struct {
	Status   string `json:"status"`
	Message  string `json:"message"`
	NsfwText bool   `json:"nsfwText"`
	NsfwPic  bool   `json:"nsfwPic"`
	Base64   string `json:"base64"`
	Filename string `json:"filename"`
}
