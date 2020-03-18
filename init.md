# Setting up OSX

## XCode
- In terminal: 
    xcode-select --install

## Homebrew
- In terminal:
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
- Run **brew doctor** to make sure that installation was successfull and that brew is working properly
- Update to the latest version:
    brew update && brew upgrade

## Git
- In terminal:
    brew install git

## Python
- Install python 3.x in homebrew with
    brew install python
- Install python dependency
    - pip3 install matplotlib
    - pip3 install scipy
    - pip3 install pandas
    - pip3 install pyodbc
    - install odbc driver for sql server
        - brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
        - brew update
        - brew install msodbcsql mssql-tools
        - (if installing msft tools doesn't work) brew install unixodbc

## VS Code
- Pull git hub repository
- Follow vscode init.md