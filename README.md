# Gaze-Contingent Experiment
Jessica Bourgin
Laboratoire de Psychologie et Neurocognition
CNRS UMR 5105
University Savoie Mont Blanc

## Requirements

This experiment was tested on Matlab R2018a and R2018b. It was tested on Windows 10.

## Usage

To test the experiment, type

```
test()
```
# Functions description

## Main (dedicated to this particular experiment)
`dummyFunction` : displays a given number of "baseline" trials (with a fixation cross displayed at the center).

`GazeContingentFace` : main function that is launched when the full experiment needs to be performed by a participant. To launch (a folder Task containing all of the images is needed):
```
GazeContingentFace()
```

`GazeContingentTraining` : main function that is launched when we want to train the participant. To launch (a folder Training containing all of the images is needed):
```
GazeContingentTraining()
```

`settingsGaze` and `UnchangingSettingsGaze` : files containing variables used in this specific experiment.

`trialFunction` : displays a given number of experimental trials (gaze-contingent or classic).

## Utils

`drawCross` : draws a fixation cross at (x,y) coordinates.

`getNumInStr` : from a list containing chars (e.g., Man1), returns a list containing only the numbers (e.g., 1).

`inEllipse` : determines if a point is contained in an ellipse or not.

`KbQueueCheckWrapper` : detects keyboard presses (and notably triggers sent in MRI). In order to use this function, at the beginning of the experiment, type:
```
KbQueueCreate(<List of Devices>)
KbQueueStart(<List of Devices>)
```
and at the end of the experiment, type
```
KbQueueStop(<List of Devices>)
```
You need also to define which keys correspond to triggers or to a stop key. In this experiment, these keys are defined in `UnchangingSettingsGaze` (`triggerKeys` and `stopkey`). They are loaded by a call to `UnchangingSettingsGaze` at the beginning of the `KbQueueCheckWrapper` function.
`KbQueueCheckWrapper` can then be called in any loop where we are interested in getting triggers or stop key (e.g., loop of stimulus/response presentation, see `trialFunction` for examples).

`proposeCalibration` : displays a text where the experimenter can choose to redo a calibration (c), a drift (d) or nothing (n).

`showText` : displays a text on the screen.

`showTextToPass` : calls `showText` function, and ends the text presentation when Enter is pressed or the mouse is clicked.

`waitCross` : calls `drawCross` function. Draws a fixation cross until either
1. The participant looks at the fixation cross (not used in MRI).
2. Or the fixation cross presentation reaches a time threshold.

`waitReleaseKeys` : waits until none of the keyboard keys are pressed anymore.
