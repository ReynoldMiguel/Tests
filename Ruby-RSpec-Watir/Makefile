run_all_in_parallel:
	make -j test_Windows10_chrome_54 test_macOS10.12_safari_10 test_Windows10_firefox_50

test_Windows10_chrome_54:
	platform="Windows 10" browserName=chrome version=54.0 name=test_Windows10_chrome_54.0 remote=false \
		make parallel_split_test

test_macOS10.12_safari_10:
	platform="macOS 10.12" browserName=safari version=10.0 name=test_macOS10.12_safari_10 remote=false \
		make parallel_split_test

test_Windows10_firefox_50:
	platform="Windows 10" browserName=firefox version=50.0 name=test_Windows10_firefox_50 remote=false \
		make parallel_split_test

parallel_split_test:
	bundle exec parallel_split_test spec