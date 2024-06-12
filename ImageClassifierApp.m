classdef ImageClassifierApp < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = private)
        UIFigure             matlab.ui.Figure
        SelectImageButton    matlab.ui.control.Button
        ClassifyButton       matlab.ui.control.Button
        ResultLabel          matlab.ui.control.Label
    end

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: SelectImageButton
        function SelectImageButtonPushed(app, event)
            [file, path] = uigetfile({'*.jpg'}, 'Select an Image');
            if isequal(file, 0)
                return;
            else
                app.ImagePath = fullfile(path, file);
            end
        end

        % Button pushed function: ClassifyButton
        function ClassifyButtonPushed(app, event)
            if isempty(app.ImagePath)
                errordlg('Please select an image first.', 'Error');
                return;
            end
            img = rgb2gray(imread(app.ImagePath));
            pixel_dist = 1;
            GLCM = graycomatrix(img, 'Offset', [0 pixel_dist; -pixel_dist pixel_dist; -pixel_dist 0; -pixel_dist -pixel_dist]);
            stats = graycoprops(GLCM, {'contrast', 'correlation', 'energy', 'homogeneity'});
            Contrast = stats.Contrast;
            Correlation = stats.Correlation;
            Energy = stats.Energy;
            Homogeneity = stats.Homogeneity;
            ciri_test = [Contrast, Correlation, Energy, Homogeneity];
            num_samples = size(app.CiriDatabase, 1);
            distance = zeros(num_samples, 1);
            for i = 1:num_samples
                distance(i) = sqrt(sum((ciri_test - app.CiriDatabase(i, :)).^2));
            end
            [~, hasil] = min(distance);
            kelas = app.Labels{hasil};  % Get the corresponding label for the closest match
            app.ResultLabel.Text = ['Class: ', kelas];
        end
    end

    % Callbacks and other functions
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            % Load feature database
            load('ciri_database.mat', 'ciri_database', 'labels');
            app.CiriDatabase = ciri_database;
            app.Labels = labels;
            app.ImagePath = '';
        end
    end

    % App initialization and construction
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 378 140];
            app.UIFigure.Name = 'Image Classifier';

            % Create SelectImageButton
            app.SelectImageButton = uibutton(app.UIFigure, 'push');
            app.SelectImageButton.ButtonPushedFcn = createCallbackFcn(app, @SelectImageButtonPushed, true);
            app.SelectImageButton.Position = [24 82 121 22];
            app.SelectImageButton.Text = 'Select Image';

            % Create ClassifyButton
            app.ClassifyButton = uibutton(app.UIFigure, 'push');
            app.ClassifyButton.ButtonPushedFcn = createCallbackFcn(app, @ClassifyButtonPushed, true);
            app.ClassifyButton.Position = [151 82 121 22];
            app.ClassifyButton.Text = 'Classify';

            % Create ResultLabel
            app.ResultLabel = uilabel(app.UIFigure);
            app.ResultLabel.HorizontalAlignment = 'center';
            app.ResultLabel.Position = [24 32 248 22];
            app.ResultLabel.Text = '';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ImageClassifierApp

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end

    methods (Access = private)

        % Code to execute on button press
        function buttonPushed(app, event)
        end
    end

    properties (Access = private)
        CiriDatabase % Feature database
        Labels % Labels
        ImagePath % Path of the selected image
    end
end
