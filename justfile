alias c := commit-push
commit-push msg:
	git add . && git commit -m "{{msg}}" && git push
