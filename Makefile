test: .FORCE
	sh test/test

test_unix:
	bash test/test
	ksh test/test
	zsh test/test

test_posix:
	dash test/test
	posh test/test
	yash test/test

test_all: test unixtest posixtest

coverage: .FORCE
	rm -rf coverage
	kcov --exclude-path=test/test coverage test/test

coveralls:
	rm -rf coverage
	kcov --coveralls-id=$$TRAVIS_JOB_ID --exclude-path=test/test coverage test/test

clean:
	rm -rf coverage

.FORCE:

# vim: noet
