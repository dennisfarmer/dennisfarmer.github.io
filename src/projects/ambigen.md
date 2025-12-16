---
layout: layouts/base.njk
title: Conditional Ambient Music Generator
image: /images/ambigen.png
date: 2025-12-15
featured: true
---

# Ambigen - Text and Audio prompted Ambient Music Generator

Final project for PAT 463 - Music and AI, Fall 2025

Dennis Farmer

![diagram.png](/images/ambigen.png)

https://github.com/dennisfarmer/ambigen

I have created a tool for creating remixes of uploaded ambient synthesizer tracks, using MusicGen, an open source transformer-based AI model that generates music from a text prompt paired with an audio sample to condition on.

I used Dash to provide a user interface, which was forwarded over an SSH connection to the Great Lakes HPC compute cluster.

default prompt: "ambient synthesizer, with warm pads, slow chord changes, counterpoint, constant motion, sustain, brian eno"
