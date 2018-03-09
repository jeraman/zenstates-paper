# First prototypes
**Date:** August 30 2016.

Two initial proposals were developed:

## Multi-paradigm left to right
![Sketch1](https://photos-3.dropbox.com/t/2/AACWA0txjr6m7jkjfA_mx7apuhmUYlYfoTMfLbWakX8sUQ/12/152159960/jpeg/32x32/3/1511409600/0/2/fsm-sketch1.jpg/EPDEsHQY5_kGIAcoBw/7Yf5xkIJZEhNOHL-zZYk618qQYNP6n6dlrD7ebkCB6A?dl=0&size=640x480&size_mode=3)
![Sketch2](https://photos-1.dropbox.com/t/2/AADd8LYQ0y5Y0kVJROsmwOxJMRpeRA57Ruce9LNqAD7pRw/12/152159960/jpeg/32x32/3/1511409600/0/2/fsm-sketch2.jpg/EPDEsHQY6PkGIAcoBw/LSJeyRqFlnJ_cvCterUn2gtgsq8xaWDc6RtVG9G1dOI?dl=0&size=640x480&size_mode=3)

## Integrated behavior tree top to bottom
![Sketch1](https://photos-1.dropbox.com/t/2/AABpMao03oSIun0mnfvoAk5I0of9WYetgRIlJJby4RFXZg/12/152159960/jpeg/32x32/3/1511409600/0/2/bt-sketch1.jpg/EPDEsHQY8fkGIAcoBw/fJtqFjKa4q3_nwptF0SgkUm8RS8wr4G9P3021Gnjo4g?dl=0&size=640x480&size_mode=3)
![Sketch2](https://photos-6.dropbox.com/t/2/AAD_M59EQUC6q3xX2WOMR4pGsJDYKwlutSPKVaADfP84-A/12/152159960/jpeg/32x32/3/1511409600/0/2/bt-sketch2.jpg/EPDEsHQY8fkGIAcoBw/Ru9qTi0O3v4fxquSxhRgn4QnJKt-Bm3K_R42OVa2MvI?dl=0&size=640x480&size_mode=3)

## Informal evaluation & Expert testing
These initial sketches were introduced to one expert users for discussion.


# Advanced paper prototype
**Date:** Sep 20, 2016.

The system is generally composed of a blackboard and a control model.

![image](https://photos-6.dropbox.com/t/2/AAAcLSLvjkhf-KRwc8rUfdCJcD81rK2ej3poa_6FbazKlQ/12/152159960/jpeg/32x32/3/1511409600/0/2/prototype1-0.jpg/EPDEsHQY9vkGIAcoBw/cwb7zGzzPULlZbx5EN1HWf8GeVPJqB4H1MTTASlmkxo?dl=0&size=640x480&size_mode=3)

#Blackboard
- Both models uses a blackboard to handle variables. Users can use these variables inside the Behavior Tree nodes or to trigger state changes;
- Could accept OSC messages from other clients (i.e. in case we want to use sensor data input);

![image](https://photos-1.dropbox.com/t/2/AAB3T7xflbZ3YfomOfG8qoSj5JIZUgD5mJfSYMq066om8w/12/152159960/jpeg/32x32/3/1511409600/0/2/prototype1-1.jpg/EPDEsHQY9vkGIAcoBw/u3tXt0m8jDxs8ArLakyeTeTak7EKd7BPsm_pMlHiwEM?dl=0&size=640x480&size_mode=3)

#Control model
Defines the rules of how the system is going to behave. Can be separated into two categories: an easy & limited (represented by Finite-State Machines, the FSM) and a complex & powerful (represented by Behavior Trees, the BT). See reference for details regarding where these categories come from.

Control models can be run and stopped by using the big buttons (see images below).

##Easy & limited model: Finite-State Machine
Simple & straightforward, but limited in power and organization.

###How does it look like?
![image](https://photos-6.dropbox.com/t/2/AABAzQq-x-dTa8Y7WEW9Gyxhlxzc4VZwMVSF1IcESt2cOQ/12/152159960/jpeg/32x32/3/1511409600/0/2/prototype1-2.jpg/EPDEsHQY9vkGIAcoBw/LPUss72gT-qlvqhXx4E96aC4t2prV71An9RD9zSqEkg?dl=0&size=640x480&size_mode=3)

###How to add states?

![image](https://photos-2.dropbox.com/t/2/AAAGK5mNyNRzvV48nmINqTt6uwyUx8nO-SwHvA7QVdrWXg/12/152159960/jpeg/32x32/3/1511409600/0/2/prototype1-3.jpg/EPDEsHQY9vkGIAcoBw/TYC56Z38omvAZTIzZ5v0cEYKmY42aD-G3hgAzJCI3hE?dl=0&size=640x480&size_mode=3)

###How to create connections between states?

![image](https://photos-3.dropbox.com/t/2/AAAwPfRfIqzPRMQ-yKSHIbw2SCu9xQ-hg7mCh734diEatw/12/152159960/jpeg/32x32/3/1511409600/0/2/prototype1-4.jpg/EPDEsHQY9vkGIAcoBw/U5fmRelrxcABBgEBbbB6KyAvfuYOmy5ivOdZK1hnFME?dl=0&size=640x480&size_mode=3)

###What actions can be associated to the states?
In priority order for the implementation:

- OSC;
- MIDI;
- DMX;
- Audio;
- Video;
- Script;
- Another state;

##Complex & powerful: Behavior Tree
Powerful but more complex to use.

###How does it look like?
![image](https://photos-3.dropbox.com/t/2/AADeA611yXyX0eRXEEC28iX2wkB1yOsElQW69wg6PxL_PA/12/152159960/jpeg/32x32/3/1511409600/0/2/prototype1-5.jpg/EPDEsHQY9vkGIAcoBw/FKmj8UKsiuoKULa505_gqJb47xpXY2ePIF_tOH0t-YI?dl=0&size=640x480&size_mode=3)

###What are our possible nodes?
In priority order for the implementation:

**Leaves:**

- OSC; MIDI; DMX; Audio; Video; Script;

**Complex:**

- Parallel;
- Sequence (regular and random?);
- Selector (regular and random?);
- Decorator (Always fail, Always succeed, include, invert, limit, repeat, until success, - until fail).

###How do I add a leaf node?
![image](https://photos-6.dropbox.com/t/2/AAAU8o_s5Q8cBiJYX3xdC1ls943EVGz1aL6taUzekeR4jQ/12/152159960/jpeg/32x32/3/1511409600/0/2/prototype1-6.jpg/EPDEsHQY9vkGIAcoBw/xnOuKiz0hSna2yJh2CEAsCUyVYdoZW4fnhU6Yv40cMM?dl=0&size=640x480&size_mode=3)

###How do I add a complex node?
![image](https://photos-2.dropbox.com/t/2/AABQL6E0dohORtDJL4AtdsZChWMATysvdZsGX-oLodoc6g/12/152159960/jpeg/32x32/3/1511409600/0/2/prototype1-7.jpg/EPDEsHQY9vkGIAcoBw/ApvqCZuX-ywBuKbKhilvYXNRLXQGEBbpq_njWc46AS4?dl=0&size=640x480&size_mode=3)

###How to create connections between states?
![image](https://photos-6.dropbox.com/t/2/AACrZ1vp4NG9Xlyo-PnDnxGWg6xnmgT_7a8ArvvanQO9cw/12/152159960/jpeg/32x32/3/1511409600/0/2/prototype1-8.jpg/EPDEsHQY9vkGIAcoBw/p1W8o25FfpC4zphQWho8LrApDSp2Uma47DkyOmsx9ew?dl=0&size=640x480&size_mode=3)

--

#Practical characteristics
- Allow users to hide/show nodes;
- Use and abuse contextual modes (e.g. Pie menu);
- Continuous feedback to show where you are when executing;
- Straightforward access to the blackboard (check & modification);
- Strong connection with other software used in media practice (MAX, Pd, ableton, processing...);'
- Combine FSM (beginners, easy-to-use) with behavior-trees (powerful, easy to keep track and debug, manageable);
- Web app (multiplatform)?

#References: FSM vs. BT
It seems there is a trade-off between ease of use and expressiveness between FSM and BT. See the following examples:

https://coffeebraingames.wordpress.com/2014/02/23/finite-state-machine-vs-behaviour-tree-a-true-story/

	I needed behaviour trees because I wanted to manage the complexity of the units AI in Warrior Defense which originally used finite state machines (FSM). FSMs are great because they are so simple and intuitive. When they get big, however, they become so complicated. It got to a point where I’m afraid to change the configuration of the FSM because the working AI easily breaks. In other words, it’s brittle. I don’t like that. I still have lots of features to add later on that deal with unit interactions.

	I can’t say that behaviour trees are better, either. They also have a major disadvantage: steep learning curve. You have to think like a compiler when working with BTs. You have to know what its elements mean like Sequence, Selector, Parallel, Decorator, etc. Like every skilled programmers say, “Know your tools. Know where it’s best used.” Behaviour trees has been proven to work on complex behaviours, but I probably can’t give this to a non programmer and let him/her figure it out on his/her own. FSMs are much more easier to understand. They are far more intuitive, too. FSMs are probably the way to go if you only need to model simple behaviours.

http://www.gamasutra.com/blogs/JakobRasmussen/20160427/271188/Are_Behavior_Trees_a_Thing_of_the_Past.php

	"[In FSM,] being able to translate from any state to any other state by specifying conditions, makes it very easy to design FSMs for AI behavior. However, it turns out this is also the drawback of the FSM approach. In professional games, FSMs can easily have hundreds of states, and at such sizes they become increasingly difficult to debug. Damian Isla outlined this in detail regarding the AI of Halo 2 at his GDC talk from 2005" <sup>2</sup>.

	"Behavior Trees in many cases provide a framework for designing more comprehensible and easier-to-read AIs than hierarchical FSMs. Also, the nicely organised tree makes for easier visual debugging in practice. However, the Behavior Tree technique has a number of shortcomings. (...) For very large behavior trees, the costs of evaluating the whole tree can be prohibitive.  The major challenge is that it does not provide a model for improving decision-making. The decision-making is locked to the conditional nodes, without specifying how decisions are made to invoke different subtrees".

https://github.com/libgdx/gdx-ai/wiki/Behavior-Trees

http://www.gamasutra.com/view/feature/130663/gdc_2005_proceeding_handling_.php
