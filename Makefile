test: .FORCE
	sh test/test

alltest: test
	echo Testing with bash ...
	bash test/test
	echo Testing with ksh ...
	ksh test/test
	echo Testing with zsh ...
	zsh test/test
	echo Testing with dash ...
	dash test/test
	echo Testing with posh ...
	posh test/test

coverage: .FORCE
	rm -rf coverage
	kcov --exclude-path=test/test coverage test/test

coveralls:
	rm -rf coverage
	kcov --coveralls-id=$$TRAVIS_JOB_ID --exclude-path=test/test coverage test/test

clean:
	rm -rf coverage

.FORCE:
