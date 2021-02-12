# import libraries
import numpy as np
from tqdm import tqdm
import matplotlib.pyplot as plt
import librosa, librosa.display
import pyroomacoustics as pra
import scipy.signal as signal
from scipy.io import wavfile
import IPython.display as ipd
from mpl_toolkits.mplot3d.art3d import Poly3DCollection, Line3DCollection
import soundfile as sf

# TODO creare segnali input 
# TODO pensare alle RIR da generare
# TODO finire il codice (jupyter2 + script con OLA)
# TODO fare power point + presentazione

# TODO ? applicazione su segnale reale finale?

# ! GENERATION of SIGNALS/RIR
# parameters
Fs = 12000

# import signal(s)

signals_path = Path('./audio/signals')
filelist = list(signals_path.rglob('*.wav'))
filelist = [f.as_posix() for f in filelist]

for file in filelist:
    print("Processing file: {}".format(file))

    audio, fs = librosa.load(file, sr=Fs)

generate_RIR(dimensions, )



audio, Fs = librosa.load('audio/OSR_us_000_0010_8k.wav', sr=Fs)

# generate RIR(s) + rev signals