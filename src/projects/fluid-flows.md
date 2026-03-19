---
layout: layouts/base.njk
title: Numerical Methods for Fluid Flow
image: /images/laminar-turbulent-flow.jpg
date: 2026-03-01
featured: true
---

![Preview](/images/laminar-turbulent-flow.jpg)

## Numerical Methods for Fluid Flow

Below is my final presentation from the UM Math Directed Reading Program.

Abstract: Estimating physical parameters from experimental data is a problem of great importance in the study of fluid flows. After introducing the Navier-Stokes equations for incompressible flow, we derive Couette flow as a concrete example of a steady-state solution around which linearization is possible. We investigate a computational approach for recovering the underlying system matrix from simulated streamline data from a linear flow field, examining the loss function landscape when the matrix is defective or ill-conditioned, as well as the effects of short-time data.

<embed class="presentation" src="/presentations/F25_DRP_Presentation.pdf" type="application/pdf">

<embed class="presentation" src="/presentations/DRP_Abstracts_F2025.pdf" type="application/pdf">

<!--
<iframe width="560" height="315" src="https://www.youtube.com/embed/o2A61bJ0UCw?si=O2L90dpHJEdFIP-E" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
-->

Below are some of my markdown notes for concepts covered and reviewed throughout the semester - seperate from my written notes.

# Multivariable Calculus

The nabla operator represents the vector of partial derivatives:
$$
\boxed{
    \nabla = \left\langle \frac{\partial}{\partial x}, \frac{\partial}{\partial y}, \frac{\partial}{\partial z}\right\rangle
}
$$

## Gradient

$$
\boxed{
    \nabla f = \left\langle \frac{\partial f}{\partial x}, \frac{\partial f}{\partial y}, \frac{\partial f}{\partial z}\right\rangle
}
$$

The gradient of a scalar function gives the direction and rate of the greatest increase.

Written as $\mathrm{grad}\,f$ and $\nabla f$.

## Divergence

$$
\boxed{
    \nabla\cdot F = \frac{\partial F_1}{\partial x} + \frac{\partial F_2}{\partial y} + \frac{\partial F_3}{\partial z} 
}
$$

The divergence of a vector field is the extent to which the vector field flux behaves like a source or a sink at a given point.

Written as $\mathrm{div}\,F$, and $\nabla\cdot F$. It is proper to write the $\nabla$ as $\vec{\nabla}$ since it behaves like a vector operator in three-dimensional space.

### Divergence Theorem

$$
\boxed{
    \int_V(\nabla\cdot F)\,dV = \int_S(F\cdot\vec n)\,dS
}
$$

The dot product $F \cdot n$ measures the component of $F$ that is perpendicular to the surface at each point, which is essential for calculating the flux through the surface.

Note: a common notation in the Chorin textbook is to use $W$ to represent a region in the fluid at a particular time $t$, and $\partial W$ to represent the surface that encloses $W$ ("the boundary of $W$").
- In topology, $\partial$ is used to denote the boundary of a set


# Week 2 recap


![image.png](figures/image.png)


density: $\rho(x, t)$

velocity: $u(x,t)$

pressure: $p(x,t)$

## Goal #1: Derive Euler’s Equation using the Net Force Equation

Net Force Equation (Newton’s second law of motion):

$$
\begin{align}
\vec F &= m\vec a\\
&= m \frac{d\vec u}{dt} = \frac{d}{dt}(m\vec a) = \frac{d\vec p}{dt}, \textrm{where }\vec p\textrm{ is momentum}\\
\end{align}
$$

## Inviscid Fluid: no (dynamic) viscosity $(\mu = 0)$

Making the assumption that there is no viscosity allows us to represent the following quantities in a simplified form:

Note: pressure is $p$, momentum is $\vec p$.

$$
\begin{align}
\textrm{Momentum in }V&=\int_V \rho\vec u\, dV\\
\underset{\textrm{(body force)}}{\textrm{Gravity force}} &= \int_V\rho\vec g \, dV\\
\textrm{Force due to pressure} &= -\int_S p\vec n \, dS
\end{align}
$$

**Question:** What are the units for the total momentum in $V$? 

Density is expressed as mass over a cubic volume, and velocity is expressed as length over time, so we have that $[\rho][\vec u]=\frac{M}{L^3}\frac{L}{T}=\frac{M}{L^2T}$.  Then, we integrate over volume, so we multiply our units by $L^3$ to get $[\vec p]=M\frac{L}{T}$

units of pressure: $[p] = \frac{F}{L^2}$

$$
\frac{d}{dt}\int_V \rho\vec{u}\,dV=-\int_Sp\vec n\,dS+\int_V\rho\vec g \,dV
$$

Leibniz integral rule (swap integral and derivative)

 

$$
\int_V\frac{\partial}{\partial t}(\rho \vec u)\,dV = -\int_Sp\vec n\,dS+\int_V\rho\vec g\, dV
$$

Divergence Theorem: $\int_V(\nabla\cdot F)\,dV = \int_S(F\cdot\vec n)\,dS$

$$
-\int_Sp\vec n\,dS = \int_V\vec\nabla p\,dV
$$

Here, because $p$ is a scalar, we write $\vec\nabla p$ instead of $\vec\nabla\cdot p$.

Now, we go back to the net force equation, which states that $\vec F=\frac{d\vec p}{dt}$. We have two forces we are considering in this simplified example: 

- Gravity force, which acts in the direction of the gravity vector
- Pressure force, which acts in the direction opposite of the normal vector of the volume

We also consider the “net rate of momentum flow into $V$” as a separate force into $V$. Because the volume is fixed but the particles are in motion, we account for the momentum of the volume changing as a result of fluid carrying momentum into or out of the volume through its boundaries. If we were dealing with solids, this would not be a factor since the particles would be fixed.

$$
\frac{d}{dt}(\textrm{momentum in V}) = \textrm{net force on V} + \textrm{net rate of momentum flow into V}
$$

## Note: Eulerian vs Lagrangian Perspective

![image2.png](figures/image2.png)

Lagrangian: $\frac{\partial f}{\partial t}$

Eulerian: $\frac{\partial f}{\partial t} + (\vec u \cdot \vec\nabla)f$

Eulerian fluid analysis focuses on fixed points in space, whereas Lagrangian fluid analysis tracks individual particles by following them around and tracking how they change over time. Eulerian is more fitting for studying overall flow characteristics.

## Back to derivation:

$$
\frac{d}{dt}(\textrm{momentum in V}) = \textrm{net force on V} + \textrm{net rate of momentum flow into V}
$$

$$
\Rightarrow \frac{d}{dt}\int_V \rho\vec{u}\,dV=-\int_Sp\vec n\,dS+\int_V\rho\vec g \,dV - \int_S(\rho\vec{u})\underbrace{(\vec u \cdot \vec n)}_\textrm{vol per time}\,dS
$$

Apply Leibnez, divergence theorem, and reorder terms / move parentheses

$$
\int_V\frac{\partial}{\partial t}(\rho \vec u)\,dV = -\int_V\vec\nabla p\,dV+\int_V\rho\vec g\, dV-\int_S(\rho\vec u \vec u)\cdot\vec n\,dS
$$

Combine like terms:

$$
\int_V\frac{\partial}{\partial t}(\rho \vec u)+  \vec\nabla p -\rho\vec g\, dV=-\int_S(\rho\vec u \vec u)\cdot\vec n\,dS
$$

divergence theorem

$$
\int_V\frac{\partial}{\partial t}(\rho \vec u)+  \vec\nabla p -\rho\vec g\, dV=-\int_V\vec\nabla\cdot(\rho\vec u \vec u)\,dV
$$

Inner expressions must be equal

$$
\frac{\partial}{\partial t}(\rho \vec u)+  \vec\nabla p -\rho\vec g +\vec\nabla\cdot(\rho\vec u \vec u)=\vec 0
$$

product rule

$$
\frac{\partial \rho}{\partial t}\vec u + \rho \frac{\partial \vec u}{\partial t} + \vec\nabla\cdot(\rho \vec u)\vec u + \rho (\vec u \cdot \vec\nabla \vec u) = - \vec\nabla p + \rho \vec g
$$

$$
\underbrace{(\frac{\partial \rho}{\partial t} + \vec\nabla\cdot(\rho\vec u))}_{=0}\vec u + \rho (\frac{\nabla \vec u}{\partial t} + (\vec u\cdot \vec \nabla)\vec u) = -\vec\nabla + \rho g
$$

Total derivative: $Df_a = [\frac{\partial f}{\partial x_1}(a) \cdots \frac{\partial f}{\partial x_n}(a)]$

$$
\Rightarrow(\frac{\partial \vec u}{\partial t}+(\vec u \cdot \vec\nabla)\vec u) = \frac{D\vec u}{D t}
$$

$$
\Rightarrow \rho \frac{D\vec u}{D t} = -\nabla p+\rho\vec g
$$

# Euler's Equations

# Law of conservation of mass
The rate of increase of mass in $W$ equals the rate at which mass is crossing $\partial W$ in the *inward* direction:

$$
\frac{d}{dt}\int_W \rho dV = -\int_{\partial W} \rho \vec{u}\cdot \vec{n} d A
$$

This is the "integral form" of the *law of conservation of mass*.


# Continuity Equation

By the divergence theorem, this is equivalent to
$$
\int_W\left[\frac{\partial\rho}{\partial t} + \mathrm{div}(\rho \vec u)\right] dV = 0
$$

Because this is true for all W, it is equivalent to:

$$
\boxed{
\frac{\partial\rho}{\partial t} + \mathrm{div}(\rho \vec u) = 0
}
$$

This is the **continuity equation**, also known as the "differential form" of the *law of conservation of mass*.


# Material Derivative

$$
\frac{D}{Dt}f = \left(\frac{\partial}{\partial t} + \vec{u}\cdot\vec{\nabla}\right)f
$$

**Main idea**: the material deriviative takes into account the fact that the fluid is moving and that the positions of fluid particles change with time.

Example: 

$$
\frac{D\vec u}{Dt} = \frac{d}{dt}\vec{u}(\vec{x}(t),t)
$$

gives the velocity following a fluid particle

# Balance of momentum

An **ideal fluid** is one with the following property:

> For any motion of the fluid there is a function $p(\vec x,t)$ called the **pressure** such that is $S$ is a surface in the fluid with a chosen unit normal $\vec n$, the force of stress exerted across the surface $S$ per unit area at $\vec x \in S$ at time $t$ is $p(\vec x,t)n$.
> Note that the force is in the direction $\mathbf{n}$ and that the force acts orthogonally to the surface $S$; that is, there are no tangental forces (see Figure 1.1.3).

![02_1](figures/02_1.png)

If $\vec{b}(\vec{x}, t)$ denotes the given body force *per unit mass*, we have the total body force $\vec B = \int_W \rho \vec b \,dV$. Thus, on any piece of fluid material, the force per unit volume is equal to $-\mathrm{grad}\,p + \rho \vec b$.

This along with Newton's second law ($F=d\rho/dt$) leads us to the differential form of the law of *balance of momentum*:

$$
\boxed{
    \rho \frac{D \vec u}{D t} = -\mathrm{grad}\,p+\rho \vec b
}
$$

In some other resources, the body force $b$ is omitted (assumed to be zero) for simplicity. However, including $b$ makes the formulation more general. Including $\rho$ on both sides covers both compressible and incompressible fluids.

*Balance* of momentum is often used interchangeably with *conservation* of momentum. The use of the word *balance* emphasizes the ongoing *equilibrium* between the forces applied to a fluid and the resulting change in its momentum - accounting for the fact inflows, outflows, and forces must be accounted for at every instant, not just that total momentum doesn't change over time.

Newton's third law ensures that momentum exchanged internally cancels out, leaving only external forces to change total momentum.


# Reynolds Transport Theorem

$$
\boxed{
    \frac{d}{dt}\int_{W_t}\rho f\,dV=\int_{W_t}\rho\frac{Df}{Dt}\,dV
}
$$

$$
\boxed{
    \frac{d}{dt}\int_{W_t} f\,dV=\int_{W_t}\left(\frac{\partial f}{\partial t}+ \mathrm{div}(f\vec u)\right)\,dV
}
$$

[momentum conservation](https://www.resolvedanalytics.com/fluid-dynamics/conservation-of-momentum-in-fluid-dynamics)


# Incompressibility

We call a flow **incompressible** if for any fluid subregion $W$,

$$
\textrm{volume}(W_t) = \int_{W_T} dV = \textrm{constant in }t
$$

The following statements are equivalent:
1) *the fluid is incompressible*
2) $\mathrm{div}\,\vec u = 0$
3) $J \equiv 1$
4) $D\rho/D t = 0$
    - "The mass density is constant following the fluid"
5) $\rho$ is constant
6) $\nabla\cdot\vec{u} = 0$

*Homogeneous* fluid means that $\rho$ is constant in space. *Incompressible* fluid means that $\rho$ is constant in time.

> [!NOTE]
> Problems involving inhomogeneous incompressible flow occur, for example, in oceanography

**Main idea**: An increasing amount of fluid cannot be stored in a fixed volume, because that would necessitate that the fluid be compressed into that volume. The rate of fluid entering must be exactly matched by the rate leaving which mathematically implies that the div of the mass flow rate is zero: An increasing amount of fluid cannot be stored in a fixed volume, because that would necessitate that the fluid be compressed into that volume. The rate of fluid entering must be exactly matched by the rate leaving which mathematically implies that the div of the mass flow rate is zero.

[Wikipedia article on incompressible flow](https://en.wikipedia.org/wiki/Incompressible_flow)


# The Euler equations
Assuming incompressibility, the *Euler equations* are:

$$
\begin{align}
\rho\frac{D\vec u}{D t} &= -\mathrm{grad}\,p + \rho \vec{b}\\
\frac{D\rho}{D t} &= 0\\
\mathrm{div}\,\vec{u} &= 0\\
\end{align}
$$

with the boundary conditions $\vec{u}\cdot\vec{n} = 0\textrm{ on }\partial D$.

1) Balance of momentum
2) Density conservation as fluid particles move (incompressibility)
3) Rate of fluid entering must exactly match the rate leaving (incompressibility)

See also: Elementary Fluid Dynamics
- David Acheson

non-linear dynamics - chaos

bifercation analysis
solution looks normal, as parameter varys solution oscillates, etc
- strogats  cornell book


Boyce D. Prima
skim chapter 2
7.1 - 7.8

- 7.1 Intro 355
- 7.2 Review of Matrices 364
- 7.3 Linear Algebraic Equations; Linear Independence, Eigenvalues, Eigenvectors 374
- 7.4 Basic Theory of Systems of First Order Linear Equations 385
- 7.5 Homogeneous Linear Systems with Constant Coefficients 390
- 7.6 Complex Eigenvalues 401
- 7.7 Fundamental Matrices 414
- 7.8 Repeated Eigenvalues 422

# Differential Equations

## First-order ordinary differential equations (ODEs) 
- involve the first derivative of a function as its highest derivative
- $y` + a(x)y = b(x)$



# 1) Systems of First Order Linear Equations

$$
x^{(n)} + a_{n-1}x^{(n-1)} + \dots + a_2x^{\prime\prime}+a_1x^\prime + a_0x = 0
$$

**Key idea**: Every higher-order ODE can be rewritten as a system of first-order ODEs.

This is done by introducing new variables for each derivative:
$$
x_1 = y,\, x_2 = y^\prime,\, x_3 = y^{\prime\prime},\,\dots,\, x_n = y^{(n-1)}
$$
Then the system becomes:
$$
x_1^\prime = x_2,\\
             x_2^\prime = x_3,\\
             x_3^\prime = x_4,\\
             \dots,\\
             x_{n-1}^\prime = x_n
$$
And we have:
$$
\begin{align}
x_n^\prime &= F(t, x_1, x_2, \dots, x_n)\\
\Rightarrow x^{(n)} &= -a_0x_1 - a_1x_2 - a_2x_3 - \dots - a_{n-1}x_n
\end{align} 
$$

This system of equations can be written in matrix form:

![04_2](figures/04_2.png)

$$
\vec x^\prime = \mathbf{A}\vec x
$$

**Key idea**: eigenvalues of $\mathbf{A}$ are roots of characteristic polynomial; eigenvalue equation of equivalent system is equivalent to characteristic polynomial of the original higher-order equation

RecalL: $\mathrm{eigs}(A) \textrm{ are } \lambda\textrm{'s that satisfy } \mathrm{det}(A-\lambda I) = 0$
![04_4](figures/04_4.png)

# 5) Homogeneous Linear Systems with Constant Coefficients


![04_5](figures/04_5.png)


For general system $\vec x^\prime = \mathbf{A}\vec x$, we want a change of coordinates $x = \mathbf{T}\vec z$ that diagonalizes my ODE

in this z-coordinate system, I want $\vec z^\prime = \mathbf{D}\vec z$, where $\mathbf{D}$ is decoupled and diagonal.

$$
\vec z^\prime = \mathbf{D}\vec z \Rightarrow \vec{z}(t) = e^{Dt}\vec z(0)
$$



# Eigenvalues

The eigenvalues $r_1,\,\dots,\,r_n$ (which need not all be different) are roots of the $n$th degree polynomial equation
$$
\mathrm{det}(\mathbf{A}-r\mathbf{I}) = 0
$$

If $\mathbf{A}$ is a real-valued matrix, there are three possibilities for the eigenvalues of $\mathbf{A}$:

1) All eigenvalues are real and different from each other.
2) Some eigenvalues occur in complex conjugate pairs.
3) Some eigenvalues are repeated.

If the eigenvalues are all real and different, then we have $n$ eigenvectors $\vec{v}_1,\,\dots,\,\vec{v}_n$ which are linearly independent. The corresponding solutions of the differential system are
$$
x^{(1)}(t) = \vec{v}_1e^{r_1t},\, \dots,\, x^{(n)}(t) = \vec{v}_ne^{r_nt}
$$

To find eigenvalues, solve $\mathrm{det}(A-\lambda I ) = 0$. For each eigenvalue $\lambda$, solve the equation $(A-\lambda I)v = 0$ to find the corresponding eigenvectors $v$.

## Eigenvalues: three cases
1) eigenvalues are real and have opposite signs; $x=0$ is a saddle point.
2) eigenvalues are real and have the same sign but are unequal; $x=0$ is a node.
3) eigenvalues are complex with nonzero real part; $x=0$ is a spiral point.

## Initial Value Problem

$$
   A=
  \left[ {\begin{array}{cc}
   a_{11} & a_{12} \\
   a_{21} & a_{22} \\
  \end{array} } \right]
$$

Compute eigenvalues $\lambda_1, \lambda_2$ and eigenvectors $v_1, v_2$.

Then the general solution is:
$$
x(t) = c_1e^{\lambda_1t}v_1 + c_2e^{\lambda_2t}v_2
$$

The constants $c_1, c_2$ are chosen to meet initial conditions

## IVP Using Diagonalization:

$$
   A=
  \left[ {\begin{array}{cc}
   a_{11} & a_{12} \\
   a_{21} & a_{22} \\
  \end{array} } \right]
$$

$$
x(t) = e^{At} x_0
$$

If $A$ diagonalizable (has $n$ linearly independent eigenvectors), then $A=PDP^{-1}$, with $D$ diagonal and $P$ invertable. The matrix $P$ has the eigenvectors as its columns. 
- If $A$ has $n$ distinct eigenvalues, it is guaranteed to be diagonalizable.
- $A^{n\times n}$ having $n$ distinct eigenvalues implies that $A$ has $n$ linearly independent eigenvectors (diagonalizable)
- converse is not necessarily true.
- If there are fewer than $n$ linearly independent eigenvectors, the matrix cannot be diagonalized

$D$ can be constructed by placing the eigenvalues on the main diagonal in any order, with zeros elsewhere. $P$ is constructed using the corresponsing eigenvectors as its columns; the order of the eigenvectors must correspond to the order of the eigenvalues in matrix $D$. 

Then, $e^{At} = Pe^{Dt}P^{-1}$, where $e^{Dt}$ is a diagonal matrix with $e^{\lambda_1t}$ and $e^{\lambda_2t}$ on the diagonal

[Steve Brunton - Motivating Eigenvalues and Eigenvectors with Differential Equations](https://youtu.be/QYS-ML_vn4k?si=Dtnq3JRmHKPDv2Mc&t=779)

## Defective matrix
[wiki article](https://en.wikipedia.org/wiki/Defective_matrix)

note: distinct eigenvalues always have linearly independent eigenvectors.

eigenvalue has geometric multiplicity $\lt$ algebraic multiplicity (defective eigenvalue)
- $A$ has fewer than $n$ distinct eigenvalues
- $\Rightarrow$ not possible to find $n$ linearly independent eigenvectors
- algebraic multiplicity: number of times eigenvalue appears as a root of the characteristic polynomial
- geometric multiplicity: number of linearly independent eigenvectors
- $\gamma(\lambda) \leq \mu(\lambda)\,, \forall \lambda$
- defect: not enough eigenvectors to form a complete basis (not diagonalizable)
- $A$ defective if and only if it does not have $n$ linearly independent eigenvectors.

- [geometric and algebraic multiplicity of eigenvalues](https://www.statlect.com/matrix-algebra/algebraic-and-geometric-multiplicity-of-eigenvalues)
- [matrix diagonalization](https://www.statlect.com/matrix-algebra/matrix-diagonalization)

- $(\lambda_1 = \lambda_2 = 2)$, algebraic mutliplicity equal to 2, $\mu(\lambda_1) = 2$
- eigenspace of $\lambda_1$ is the linear space that contains all vectors $v_1$ of the form: $v=v_{11}\cdot [1\, 0]^T + v_{21}\cdot [0\, 1]^T$, eigenspace has dimension 2, geometric multiplicity equal to 2, $\gamma(\lambda_1) = 2$

Two cool notes
- Matrix Power: $A^n = PD^nP^{-1}$
- Matrix Inverse: $A^{-1} = PD^{-1}P^{-1}$

$$
   D^{-1}=
  \left[ {\begin{array}{cc}
   1/D_{11} & 0 \\
   0 & 1/D_{22} \\
  \end{array} } \right]
$$

## Repetition of eigenvalues

pg 398




## Condition Number
https://www.google.com/search?q=condition+numbers+of+a+matrix&rlz=1C5CHFA_enUS1119US1119&oq=condition+numbers+of+a+matrix&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIGCAEQRRg5MgoIAhAAGAoYFhgeMg0IAxAAGIYDGIAEGIoFMg0IBBAAGIYDGIAEGIoFMgoIBRAAGIAEGKIEMgoIBhAAGKIEGIkF0gEINTE5OGowajGoAgCwAgA&sourceid=chrome&ie=UTF-8

[cs357](https://cs357.cs.illinois.edu/textbook/)

[Condition Numbers - Numberical Methods Course](https://cs357.cs.illinois.edu/textbook/notes/condition.html)


# Loss Function Analysis

**Semi simplicity**: 
- equivalent to being diagonalizable for algebraically closed fields (field of complex numbers, not but not the field of real numbers)


**diagonalizable**:
- non-defective
- means there are enough independent eigenvectors
- high condition number is a sign that a matrix is nearly non-diagonalizable
- near-defective matrices exhibit unstable numerical properties and high sensitivity to perturbations (indicated by large condition numbers)




A square matrix that is not diagonalizable is called defective. It can happen that a matrix $A$ with real entries is defective over the real numbers, meaning that $A=PDP^{-1}$ is impossible for any invertible $P$ and diagonal $D$ with real entries, but it is possible with complex entries, so that $A$ is diagonalizable over the complex numbers. For example, this is the case for a generic rotation matrix.


## 

Here we assume $T<<1$

$$
J(\theta) = \int_0^T \| \vec x_\theta(t) - \vec x(t) \|^2 \,\text{d}t
$$

$$
\frac{\partial J}{\partial \theta_i} = \int_0^T \frac{\partial}{\partial\theta_i}\left[ (x_\theta - x) \cdot (x_\theta - x)\right]\,\text{d}t = 0,\, \forall i=1,2,3,4
$$


















## Condition Number
https://www.google.com/search?q=condition+numbers+of+a+matrix&rlz=1C5CHFA_enUS1119US1119&oq=condition+numbers+of+a+matrix&gs_lcrp=EgZjaHJvbWUyBggAEEUYOTIGCAEQRRg5MgoIAhAAGAoYFhgeMg0IAxAAGIYDGIAEGIoFMg0IBBAAGIYDGIAEGIoFMgoIBRAAGIAEGKIEMgoIBhAAGKIEGIkF0gEINTE5OGowajGoAgCwAgA&sourceid=chrome&ie=UTF-8

[cs357](https://cs357.cs.illinois.edu/textbook/)

[Condition Numbers - Numberical Methods Course](https://cs357.cs.illinois.edu/textbook/notes/condition.html)
