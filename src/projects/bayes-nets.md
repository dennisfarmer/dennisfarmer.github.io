---
layout: layouts/base.njk
title: Scientific Theories as Bayesian Networks
image: /images/bayes-nets.jpg
date: 2023-08-14
featured:
---

![Preview](/images/bayes-nets.jpg)

## Scientific Theories as Bayesian Networks

<!--
In the end, we decided that we had learned a lot, but we didn't have a clear way forward on the project. Not everything works out the way you think or hope it will. That's science. - Patrick Grim
-->

[View GitHub Repository](https://github.com/dennisfarmer/bayes-nets/tree/main)

The repository above contains code developed for a research project I worked on with philosopher in residence Dr. Patrick Grim, as well as with other students from various backgrounds, at the UM Center for Complex Systems. 

Our project involved the modeling of scientific theories as causal Bayesian networks. We would like to encode a "theory of the world" as a network of statements with differing degrees of belief, with statements being connected by directed arrows to represent "conceptual support": A->B says that if there was high evidence that A was to be true, then B is likely true as well, and if A were to be disconfirmed, we would have less belief in B. This theory of the world would accept a stream of evidence from the real world, and use this evidence to adapt our theory to closer match the world.


<embed class="presentation" src="/presentations/gcastle-notes.pdf" type="application/pdf">

<!--
<iframe width="560" height="315" src="https://www.youtube.com/embed/o2A61bJ0UCw?si=O2L90dpHJEdFIP-E" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
-->
