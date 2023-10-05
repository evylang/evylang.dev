# evylang.dev

`evylang.dev/docs` contains the static contents of https://evylang.dev served
via GitHub pages. The contents are HTML redirects for go modules, so that we
can use custom import paths, e.g:

	go run evylang.dev/pratt@latest

`main.go` in the repo root generates the `docs` directory contents for a given
go module and repo name, creating a redirect for:

	evylang.dev/<repo>

to

	github.com/evylang/<repo>

`make` ensures that all contents are generated and up to date for the
repos/modules listed in the `Makefile`.