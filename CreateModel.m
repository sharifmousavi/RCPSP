function model = CreateModel(filename)
    % Open the .sm file
    fileID = fopen(filename, 'r');
    if fileID == -1
        error('File not found');
    end

    % Initialize variables
    PredList = {};
    SuccList = {};
    t = [];
    R = [];
    Rmax = [];
    N = 0; % Initialize number of jobs

    % Read through the file line by line
    while ~feof(fileID)
        line = fgetl(fileID);
        
        % Check for the number of jobs in PROJECT INFORMATION
        if contains(line, 'PROJECT INFORMATION')
            % Skip the header lines
            fgetl(fileID); % Skip the first header line
            line = fgetl(fileID); % Read the next line
            parts = str2num(line); % Convert line to numeric array
            N = parts(2); % Set N to the number of jobs
            PredList = cell(1, N+2); % Initialize PredList based on N
            SuccList = cell(1, N+2); % Initialize SuccList based on N
        end
        
        % Check for the start of Precedence Relations
        if contains(line, 'PRECEDENCE RELATIONS')
            % Skip the header lines
            fgetl(fileID); fgetl(fileID);
            while true
                line = fgetl(fileID);
                if contains(line, 'REQUESTS/DURATIONS')
                    break; % Exit when reaching the next section
                end
                if isempty(line) || startsWith(line, '************************************************************************')
                    continue; % Skip empty lines or separators
                end
                % Parse the precedence relations
                parts = str2num(line); % Convert line to numeric array
                jobnr = parts(1);
                successors = parts(4:end); % Get successors
                % Update the successor list
                SuccList{jobnr} = successors;
                % Update the predecessor list
                for succ = successors
                    if succ <= N % Check if succ is within bounds
                        PredList{succ} = [PredList{succ}, jobnr]; % Add jobnr to the successors' predecessor list
                    end
                end
            end
        end
        
        % Check for the start of Requests/Durations
        if contains(line, 'REQUESTS/DURATIONS')
            % Skip the header lines
            fgetl(fileID); fgetl(fileID);
            while true
                line = fgetl(fileID);
                if contains(line, 'RESOURCEAVAILABILITIES')
                    break; % Exit when reaching the next section
                end
                if isempty(line) || startsWith(line, '------------------------------------------------------------------------')
                    continue; % Skip empty lines or separators
                end
                % Parse the requests/durations
                parts = str2num(line); % Convert line to numeric array
                if length(parts) < 4
                    % Skip lines with fewer elements
                    continue;
                end
                duration = parts(3); % Get duration
                t(end+1) = duration; % Store duration
                R(end+1, :) = parts(4:end); % Store resource requirements
            end
        end
        
        % Check for the start of Resource Availabilities
        if contains(line, 'RESOURCEAVAILABILITIES')
            % Skip the header line
            fgetl(fileID);
            line = fgetl(fileID);
            Rmax = str2num(line); % Read resource availabilities
        end
    end

    fclose(fileID);

    % Prepare the model structure
    model.N = N; % Number of jobs
    model.t = t; % Durations
    model.PredList = PredList; % Precedence relations
    model.nR = size(R, 2); % Number of resources
    model.R = R; % Resource requirements
    model.Rmax = Rmax; % Resource availabilities
end
