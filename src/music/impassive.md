---
layout: layouts/base.njk
title: Impassive
image: /images/impassive.jpg
date: 2021-10-16
featured: false
---

## Impassive

Description

![artwork](/images/impassive.jpg)

<iframe width="560" height="315" src="https://www.youtube.com/embed/-Y9Iod7U6B8?si=70XjKqQkhMNeKEfT" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

<iframe width="560" height="315" src="https://www.youtube.com/embed/HH0wMSKw8T0?si=you956edhLVDq617" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>

<embed class="score" src="/scores/impassive.pdf" type="application/pdf">

A generative neural network script written by <a href="https://github.com/msieg">msieg</a> has been adapted to add video and audio enhancement to the resulting video.

---

An 8D audio generator / midi parser has been written in Python to create an "audio moving from ear to ear" illusion that was inspired by the Pokemon Mystery Dungeon: Explorers of Sky soundtrack (it's very tasteful when used right). For the specific timings of the effects, see the `effects.json` file (negative `ear` values represent the sound being in the left ear, and positive ones represent the right ear). All of the scripts work together to apply the effects given in the json to the audio track using different types of functions (sine, sawtooth, linear, ...).

The music is in the form of six related Musescore `.mscz` files, which contain parts within them that can be exported to wav and mixed with FFmpeg, SoX, and Python to compensate for Musescore audio output quality.

The BigGAN script generates a square video, which has been mirrored over multiple axies. Image parameters (what images show up) were chosen from a list of <a href="https://gist.github.com/yrevar/942d3a0ac09ec9e5eb3a">ImageNet class indices</a>.

> 663 monastery, 947 mushroom, 642 marimba/xylophone, 782 CRT screen, 624 library, 909 wok, 541 drum, 815 spider web, 978 seashore/coast, 789 shoji (japanese windows), 508 computer keyboard, 429 baseball

For a surface-level explaination of the BigGAN magic used to generate the video, see the following medium.com article: 
<a href="https://towardsdatascience.com/the-deep-music-visualizer-using-sound-to-explore-the-latent-space-of-biggan-198cd37dac9a">The Deep Music Visualizer: Using sound to explore the latent space of BigGAN</a>

More examples: https://www.instagram.com/deep_music_visualizer/

## Installation

Install Musescore <a href="https://musescore.org/en/download">here</a>, and in your preferences set your export sample rate to 48000 Hz:

[](/images/musescore_preferences.png)

Update the Makefile's `MSCORE` variable to point towards your command line musescore executable. For Windows/Linux, just export each of the scores as `.wav` files manually.

With conda installed, run the following
```zsh
git clone https://github.com/dennisfarmer/deep-music-visualizer.git
cd deep-music-visualizer
pip install conda
conda env create -f environment.yml
conda activate ganmusicvis
```

If you are on Linux, you may also need to run:

```zsh
apt-get update
apt-get install ffmpeg
apt-get install libsndfile1
```

On MacOS, you might need to run:

```zsh
brew install ffmpeg
brew install libsndfile  # notice missing '1' compared to Linux
```

On Windows, you might need to run:

```zsh
# I bet powershell can't do this!
bash www.apple.com/purchase.sh --macbook_pro_13
```

## How to run

See original repository for details on `visualize.py` parameters.

Using Musescore, export the score parts (Vibe, Bells, and Marimba) from the three .mscz files to the `./media` directory of the repository using `make mscore` or manually, then run either `make gan build` or one of the following to compile the music and audio into a music video.

```zsh
# construct a 512x512 neural network audio visualization of the unaltered audio (Impassive.wav)
# *Note: will take ~3.3 hours on an average desktop without CUDA cores
make gan

# using preexisting 512x512 video, apply video and audio filters
# (equivalent to 'make audio video')
make build

# mix audio tracks together and add effects to result in an
# Impassive-Wet.wav file to be added to the video
make audio

# use the generated 512x512 video to create a 1920x1080 altered version
# of the video, mirroring over the y-axis and on the outer edges as well
# as adding other effects. Runs 'make merge' to import generated audio
make video

# mix audio, then merge the audio to 'Impassive.mkv'
# (equivalent to 'make audio merge')
make amerge

# see ./Makefile for additional rules
```