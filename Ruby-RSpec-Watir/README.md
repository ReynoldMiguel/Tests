## Ruby-RSpec-WatirWebdriver

### Environment Setup

1. Global Dependencies
    * Install [Ruby](https://www.ruby-lang.org/en/documentation/installation/)
    * Or Install Ruby with [Homebrew](http://brew.sh/)
    ```
    $ brew install ruby
    ```
    * Install [Rake](http://docs.seattlerb.org/rake/)
    ```
    $ gem install rake
    ```
    * Install bundler (Sudo may be necessary)
    ```
    $ gem install bundler
    ```

2. Sauce Credentials
    * In the terminal export your Sauce Labs Credentials as environmental variables:
    ```
    $ export SAUCE_USERNAME=<your Sauce Labs username>
	$ export SAUCE_ACCESS_KEY=<your Sauce Labs access key>
    ```

3. Project Dependencies
	* Install packages (Use sudo if necessary)
	```
	$ bundle install
	```

### Running Tests

* Tests in Parallel:
	```
	$ make run_all_in_parallel
	```
* Set number of processes:

    ```
    $ export PARALLEL_SPLIT_TEST_PROCESSES=<Number of processes>
    ```

### Advice/Troubleshooting

1. There may be additional latency when using a remote webdriver to run tests on Sauce Labs. Timeouts or Waits may need to be increased.
    * [Selenium tips regarding explicit waits](https://wiki.saucelabs.com/display/DOCS/Best+Practice%3A+Use+Explicit+Waits)

# Web Scripting Exercise
### Step 1: 
Start on BBC.com
### Step 2: 
Search for "World Market"
### Step 3: 
When the results are displayed, do a count of the number of articles returned. 
####  Test Case 1: 
"Search Results Page: Ensure that the article search results page displays a maximum of 10 results on the first page." 
Click the "Show more results" button 10 times; each time, validate that another 10 results are displayed. 
####   Test Case 2-11: 
"Search Results Page 2 (..11): Ensure that the Show more results button on the article search results page displays 10 additional results each time it's clicked."
 
 Note: Treat each click of this button as a new test case with its own assertion. 
#### Step 4: 
After all 10 Pages are displayed, parse the data that is returned and in the console, output the number of times "London market report" is displayed in the list in the following format: 
 "The Search Term of 'World Market' contains [ insert number here ] references to articles relating to the 'London market report'. " 
#### Step 5: 
* Upload your work to Github.  
* Name your Repo: "[your name]-T-[date of repo creation]-C-[Your Initials]"
* Create a README.md file that includes installation and execution instructions.
* Include a brief explanation of your approach in your README, including future enhancements and compromises made.  
* Push your project to Github and reply with a URL to the Github repository.
#### Step 6:
 The test cases in steps 3 and 4 are far from sufficient for testing this search results page.  Please add a section to your README called "Test Cases To Be Implemented" and add some cases that you feel would improve your confidence for deploying this page to production.
*  Bonus 1: Allow your script to take a command line argument that allows you to change the browser between Firefox and Chrome 
*  Bonus 2: Output the number of articles named “London market report” on months that have less than 31 days and then the number of the same that occur on months with 31 days.
*  Bonus 3: Generate an HTML Report from the test results.
*  Bonus 4: Set up your tests to run against a headless browser (Look into what WatiR offers).
####  Prerequisites
* You must use the Ruby WatiR Framework. 
* You must use ruby's Test/Unit class 
  
  
### Test Cases To Be Implemented
* Verify Page Title
* Verify url
* Verify Footer section loads
* Verify Sign-in
* Verify Header links load properly
* Verify +'ve, -'ve, boundary, special character search values
* Verify all links load properly
* Verify SEO/Meta-data