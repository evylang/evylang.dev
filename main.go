package main

import (
	_ "embed"
	"html/template"
	"os"
	"path"
)

//go:embed index.html.tmpl
var tmplStr string
var tmpl = template.Must(template.New("html").Parse(tmplStr))

func main() {
	mods := os.Args[1:]
	for _, mod := range mods {
		if err := genIndexHTML(mod); err != nil {
			panic(err)
		}
	}
}

func genIndexHTML(mod string) error {
	data := struct{ Mod string }{Mod: mod}
	dir := path.Join("docs", mod)
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return err
	}
	f, err := os.Create(path.Join(dir, "index.html"))
	if err != nil {
		return err
	}
	defer f.Close()
	return tmpl.Execute(f, data)
}
