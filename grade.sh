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

if [ $? -eq 0 ]; then
    echo "All test passed."
    echo "Score: 100%"
    exit 0
fi

tests_run=$(grep -o 'run: [0-9]*' junit_output.txt | grep -o '[0-9]*')


failures=$(grep -o 'Failures: [0-9]*' junit_output.txt | grep -o '[0-9]*')


correct=$((tests_run-failures))

# Calculate grade

echo "Test run:" $tests_run "failed:" $failures "correct:" $correct

echo "Score:" $((correct/tests_run))"%"

# Back to original directory

cd ..

