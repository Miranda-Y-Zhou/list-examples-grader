CPATH='.:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar'

# clean up any previous student submissions and grading areas
rm -rf student-submission
rm -rf grading-area

# Create a new grading area
mkdir grading-area

# Git clone the student repository 
git clone $1 student-submission
echo 'Finished cloning'

# Define variables for file path
DIR_NAME="student-submission"
FILE_NAME="ListExamples.java"
FILE_PATH="student-submission/ListExamples.java"

# Check if the expected file exists
if [ ! -f "student-submission/ListExamples.java" ]; then
    # Provide feedback and exit if the file does not exist
    echo "Error: Expected file '$FILE_NAME' not found in the submission."
    exit 1
fi

echo "Student code has the correct file submitted."

# Copy relevent files for grading into grading-area

cp "student-submission/ListExamples.java" "grading-area"

cp "TestListExamples.java" "grading-area"

cp "GradeServer.java" "grading-area"

cp "Server.java" "grading-area"

echo "All java files are copied into the grading-area directory"

# Complie all the java files

# Change working directory into grading area

cd grading-area

javac -cp $CPATH *.java &> "javac_output.txt"

# Check the exit status of the last command (javac)
if [ $? -ne 0 ]; then
    echo "Compilation failed:"
    grep "error" javac_output.txt
    exit 1
else
    echo "Compilation successful."
fi

# Run JUnit Tests

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples &> "junit_output.txt"

tests_run=$(grep "Tests run" junit_output.txt | awk '{print $3}')
failures=$(grep "Tests run" junit_output.txt | awk '{print $5}')

if [ $? -ne 0 ]; then
    grep "Tests run" junit_output.txt
    echo "Test not passed"
    exit 1
else
    echo "All test passed."
    
fi

cd ..

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
