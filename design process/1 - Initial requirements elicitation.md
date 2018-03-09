# Initial requirements elicitation
**Date:** August 15 2016.

## Motivation
- Tools for artists such as Max/MSP are hard to sequence cues beyond basic (eg. non linear control);
- Go beyond basic timeline & interactiveness: Incorporate notion of agent as an approach to control;
- Challenges from a HCI perspective: (a) "Low ‘‘Entry Fee’’ with No Ceiling on Virtuosity"; (b) creativity support tool, user-centered;

## Goal
- To control/sequence the states/timeline(timing?)/behavior tree;
- Support basic media (video/audio)?
- Cue triggering in other platforms? Controlling States!

## Users
- Performers (Vjs, musicians, visual artists)?
- Artists/conductor willing a centered tool to control their multimedia pieces?
- Students learning creative tech tools (e.g. MAX, Pd, OF, Processing);

## Design guidelines
- Easy-to-use, intuitive;
- Based on user-centered design;
- Playful;
- Incremental finer-grain controls as the user's expertise advances (e.g. if users are really experts, they can start coding their own functionalities);
- Modular, extendable via plugins;
- Support standard protocols in new media practice (i.e. MIDI, OSC, DMX, Arduino) as input and output;
- Open-source & Cross-platform (Mac & Linux & Windows, in laptops);
- realtime, for live performances, but latency is not critical;

## Alternatives available today
### ZeroMCue
Link: [http://zeromq.org/](http://zeromq.org/)

### Qlab
Link: [https://figure53.com/qlab/](https://figure53.com/qlab/)

- Commercial, Stable, with advanced functionalities
- Mac only;
- Paid;
- Simple cueing based on timelines;

### Vezer
Link: [http://imimot.com/vezer/](http://imimot.com/vezer/)

- Commercial, Stable, with advanced functionalities
- Mac only;
- Paid;
- Simple cueing based on timelines;

### ShowCueSystem
Link: [http://www.showcuesystems.com](http://www.showcuesystems.com)

- Commercial, stable, with advanced functionalities
- Windows only;
- Paid;
- Simple cueing based on timelines;


### Openshow
Link: [https://github.com/mapmapteam/openshow](https://github.com/mapmapteam/openshow)

- Open-source & in its beginnings (we can model it to our needs);
- Lots of work to do;
- Simple cueing based on timelines;

### Duration
Link: [http://www.duration.cc/](http://www.duration.cc/)

- Open-source;
- No support to MIDI, DMX;
- Simple cueing based on timelines;


### Libmapper
Link: [https://libmapper.github.io/](https://libmapper.github.io/)

- Support users to create advanced mappings for realtime applications;
- No support to MIDI, DMX;
- Not focused on cue triggering, and in events happening overtime;


### IanniX
Link: [http://www.iannix.org/en/](http://www.iannix.org/en/)

- Affords complex triggering;
- Can be connected to other tools such as the Arduino, ;
- Supports OSC and MIDI;
- Open-source;
- Already complex for new users (needs better argumentation)???? hard for non-tech & non-programmers artists;


### Behavioral trees
Link: [here](http://www.gamasutra.com/blogs/ChrisSimpson/20140717/221339/Behavior_trees_for_AI_How_they_work.php)

- Complex cueing (i.e. more complex than a simple timeline)
- Not focused on cue triggering;

## References

***Problems and Prospects for Intimate Musical Control of Computers, by Wessel and Wright, 2002.***

About instruments with "Low ‘‘Entry Fee’’ with No Ceiling on Virtuosity"

***IanniX: Aesthetical/Symbolic visualisations for hypermedia composition***

Paper explaining one of the alternatives: the Iannix.

***Interaction design, beyond Human-computer Interaction***

Common text-book in HCI, that has a nice perspective on the user-centered design cycle.

# Informal conversations with experts
**Date:**  September 13 2016.
## Chris Salter
 [Chris Salter](chrissalter.com) is professional media artist who shared challenges & thoughts about tools he uses today in his practice. To make his points, Chris used as examples some previous & recent works, namely:

- [**The N-Polytope**](http://chrissalter.com/projects/n-polytope-paris-2015/);
- [**Haptic Field**](http://chrissalter.com/projects/haptic-field-2016/);

### Problems with timeline software
- Unnatural, not intuitive. "I do not think in timeline as in audio";

- You need to think about duration in order to compose (e.g. the introduction has 30 secs). Unfortunately, this is not desired in some cases;

### Problems with dataflow  
- Powerful, but it is hard to keep track of time: Where am I right now?

- Massive patch, not modularized: People get lost when debugging it (e.g. Ian struggled in debugging alone a massive patch in China);

### Problems with scripting  
- Hard to learn for non-tech...

### Problems with show control  
- Similar to timeline software.

### Summary: States, not timeline!
- Chris thinks differently about time: It's not about timeline, but about _state changing_;

- States could be thought as a set of variables that can be manipulated in the piece. For example, in Haptic fields there are for main states (burst, chase, sub, and f(?)). States can be changed according to users actions (state machine) or internal conditions (e.g. random). Each state has a set of media (e.g. light, sound, etc). These media are composed of a set of smaller variables (speed, intensity, etc) that can be concretely manipulated by the patch;

### Case studies
After that, we tried to apply the concept of behavior trees into the logic of the Haptic fields and the N-Polytope. Our goal was to test if Behavior Trees could work in a real-life context. It seems it works! As follows:

#### Haptic field

(Add picture here)

#### N-Polytope

(Add picture here)

## Harry Smoak
The artist [Harry Smoak](http://www.harrysmoak.com/bio/) shared his previous experiences in audiovisual performance:

- Audience would need a clear sequence;
- States to organize things conceptually;
- States define behavior over time;
- Importance of teamwork in his practice. There was a conversation (intense OSC exchange) between performers. Sometimes, they wanted to see, for example, how the sound was coded so that they would ask for specific parameters to be sent over OSC;
- How do we deal with transitions between states?
