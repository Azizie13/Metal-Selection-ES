## Metal Selection Expert System
![image](https://user-images.githubusercontent.com/67861784/177036053-3da29498-8c14-4823-9c43-732e37ca7dde.png)

What is an expert system?
An expert system is a computer program that uses artificial intelligence (AI) technologies to simulate the judgment and behavior of a human or an organization that has expert knowledge and experience in a particular field.

Rules of the expert system:
Located inside the full_metal_selection v2.clp file. 

## GUI Features
1. Press 'run the program cycle' to start.
2. The system will ask you what kind of requirement do you want for your chassis.
3. Press 'run the program cycle' again to go to the next prompt.
4. Repeat until the program output its result.

## Setup
This project requires [Poetry](https://python-poetry.org/) to install the required dependencies in Python, but you'll have to go [here](https://www.clipsrules.net/) and install Clips manually.
Check out [this link](https://python-poetry.org/docs/) to install Poetry on your operating system.

Make sure you have installed [Python](https://www.python.org/downloads/) 3.9 (Clipspy currently won't work with Python 3.10)! Otherwise Step 3 will let you know that you have no compatible Python version installed.

1. Clone/Download this repository
2. Make sure CLIPSDOS has been installed. 
2. Navigate to the root of the repository
3. Run ```poetry install``` to create a virtual environment with Poetry
4. Run ```poetry run python main.py``` to run the program. Alternatively you can run ```poetry shell``` followed by ```python main.py```

## Troubleshooting
Clipspy currently won't work with Python 3.10
