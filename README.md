# ConvLSTM2D_example
Example of ConvLSTM2D


Reference link 
* https://www.kaggle.com/kcostya/convlstm-convolutional-lstm-network-tutorial

* https://keras.io/examples/vision/conv_lstm/

Dataset Link (paper link)
https://ieeexplore.ieee.org/document/9108216/algorithms?tabFilter=dataset#algorithms

- I used "ap184016", "ap184192", "ap185166", "ap184194", "ap184145", "ap185165", "ap184193","ap184014" for ap data patch
- The location of AP in data patch is as follows: [1,1;1,2;2,1;1,3;2,2;2,3;1,4;2,4]; (in matlab)
- The pre-processed data I used is data_map.mat, and the code for generating this data is  "trafficData470_DA.m"
- making shifted&windowed dataset for this training is .ipynb file



