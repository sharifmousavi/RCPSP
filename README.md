# RCPSP
Codes for Resource Constrained Project Scheduling Problem (RCPSP) Resolution


# CreateModel - MATLAB Function to Read and Parse PSPLIB Project Files (.sm)
## Overview
CreateModel is a MATLAB function designed to read and parse PSPLIB project files (.sm). This function extracts project information, precedence relations, requests/durations, and resource availabilities from the .sm file and organizes them into a structured model.

## Features
Reads and parses PSPLIB project files (.sm)

Extracts project information, including the number of jobs

Parses precedence relations and updates predecessor and successor lists

Extracts requests/durations and resource requirements

Reads resource availabilities

Organizes the extracted data into a structured model

## Usage
To use the CreateModel function, simply call it with the filename of the .sm file as an argument:

## matlab

model = CreateModel('filename.sm');

## Example
## matlab

  % Example usage of the CreateModel function
  filename = 'J12060_1.sm';
  model = CreateModel(filename);
  % Display the extracted model information
  disp(model);


## Model Structure
The CreateModel function returns a structured model with the following fields:

N: Number of jobs

t: Durations of each job

PredList: Precedence relations (predecessor list)

SuccList: Precedence relations (successor list)

nR: Number of resources

R: Resource requirements

Rmax: Resource availabilities

## License
This project is licensed under the MIT License. See the LICENSE file for details.
