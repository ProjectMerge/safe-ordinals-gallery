package models

type RawTX struct {
    Txid     string `json:"txid"`
    Version  int    `json:"version"`
    Locktime int    `json:"locktime"`
    Vin      []Vin  `json:"vin"`
    Vout     []Vout `json:"vout"`
    Size     int    `json:"size"`
    Weight   int    `json:"weight"`
    Fee      int    `json:"fee"`
    Status   Status `json:"status"`
}
type Prevout struct {
    Scriptpubkey        string `json:"scriptpubkey"`
    ScriptpubkeyAsm     string `json:"scriptpubkey_asm"`
    ScriptpubkeyType    string `json:"scriptpubkey_type"`
    ScriptpubkeyAddress string `json:"scriptpubkey_address"`
    Value               int    `json:"value"`
}
type Vin struct {
    Txid         string   `json:"txid"`
    Vout         int      `json:"vout"`
    Prevout      Prevout  `json:"prevout"`
    Scriptsig    string   `json:"scriptsig"`
    ScriptsigAsm string   `json:"scriptsig_asm"`
    Witness      []string `json:"witness"`
    IsCoinbase   bool     `json:"is_coinbase"`
    Sequence     int64    `json:"sequence"`
}
type Vout struct {
    Scriptpubkey        string `json:"scriptpubkey"`
    ScriptpubkeyAsm     string `json:"scriptpubkey_asm"`
    ScriptpubkeyType    string `json:"scriptpubkey_type"`
    ScriptpubkeyAddress string `json:"scriptpubkey_address"`
    Value               int    `json:"value"`
}
type Status struct {
    Confirmed   bool   `json:"confirmed"`
    BlockHeight int    `json:"block_height"`
    BlockHash   string `json:"block_hash"`
    BlockTime   int    `json:"block_time"`
}
