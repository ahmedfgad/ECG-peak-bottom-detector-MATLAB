# signal-peak-bottom-finder-MATLAB

This project detects the peaks and bottoms of ECG image signals using MATLAB. 

The project has a single file called `peakFinder.m` which has a function with the same name with the following signature:
```MATLAB
function [detectedPeaks, detectedBottoms] = peakFinder(signal)
```

It accepts the image name as text and returns the 2 matrices `detectedPeaks` and `detectedBottoms`.

For each detected peak or bottom, 2 values are inserted into the corresponding matrix. The 2 values refer to the Y and X of the detected peak/bottom. So, if there are 4 peaks detected, then the size of the `detectedPeaks` matrix is `(1, 8)`.

The [example.jpg](https://github.com/ahmedfgad/signal-peak-bottom-finder-MATLAB/blob/main/example.jpg) image is shown below.

![example](https://user-images.githubusercontent.com/16560492/151713305-24804968-bcc9-4a60-a8b9-8556b49d281c.jpg)

After calling the `peakFinder()` function, the [detected_peaks_bottoms](https://github.com/ahmedfgad/signal-peak-bottom-finder-MATLAB/blob/main/detected_peaks_bottoms.png) image marks the peaks with green dots and bottoms with red dots.

![detected_peaks_bottoms](https://user-images.githubusercontent.com/16560492/151713316-f50bfa10-c3d8-40d6-9349-5b8b8712d549.png)

This is the output after printing the `detectedPeaks` matrix. Because there are 12 peaks detected, then the size of this matrix is `(1, 24)`.
```MATLAB
detectedPeaks =

 Columns 1 through 13:

     9    11     6    35     9    58    11    83    12   107    12   132    10

 Columns 14 through 24:

   159    12   188    15   224    17   264    17   309     1   350
```

This is the output after printing the `detectedBottoms` matrix.
```MATLAB
detectedBottoms =

 Columns 1 through 13:

    77     9    77    33    76    57    78    81    77   106    77   131    77

 Columns 14 through 24:

   157    79   186    82   223    82   263    82   307    88   350
```
