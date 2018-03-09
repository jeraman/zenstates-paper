# Preliminary scenario 1
**Date:** Nov 16, 2016.

The goal here was to investigate to what extent FSMs and BTs are able to model a hypothetical scenario defined by one expert artist.

In short, yes, they were able.

The scenario was orally described by the artist. Characteristics of the scenario include:

- 3 types of sensor: pulse, breathing, GSR.
- Setup with mirrors.

# Tentative behavior tree
Our first scenario implemented using [Behavior Trees](https://en.wikipedia.org/wiki/Behavior_tree).

* sequence: "initialize"
	* switch everything off
	* start ambient sound
	* init vibropixel
	* bb[pulse_0] = 0
	* bb[pulse_1] = 0
	* bb[ambient_sound] = 0
	* bb[amplitude] = 0
* wait for trigger
* parallel:
	* parallel (decorator: repeat)
		* vibropixel-osc: "/pulse/0 $bb[pulse_0]"
		* vibropixel-osc: "/pulse/1 $bb[pulse_1]"
		* maxmsp-osc: "/sound/ambient $bb[ambient_sound]"
		* dmx: "/light/0 $bb[light_0_r] $bb[light_0_g] $bb[light_0_b]"
	* sequence: "main loop"
		* sequence "introduction" (decorator: repeat for X seconds)
			* bb[amplitude] = value() % script?
			* bb[ambient_sound] = bb[amplitude]
			* bb[pulse_0] = bb[amplitude] * bb[input_1]
			* bb[pulse_1] = bb[amplitude] * bb[input_0]
		* parallel "the self appears" (decorator: repeat for X seconds)
			* parallel "light control" (stop if one success)
				* parallel (dectorator: repeat)
					* bb["lights"][i]["r"] = sinewave()
					* bb[light_0_r] = sinewave()
					* bb[light_0_g] = sinewave()
					* bb[light_0_b] = sinewave()
				* sequence "light configurations"
					* sequence "configuration 1"
						* bb[light_0_on] = 1
						* bb[light_1_on] = 0
						* wait(5)
					* "configuration 2"
					* "configuration 3"
			* paralel "sound"
				* change the ambient amplitude
				* random "start random sounds"
					* sound 1
					* sound 2
					* sound 3
					* no sound
			* "pulses"
			* control parameters of lights (channels, intensity) (DMX)
			* the ambient sound continues (with varying amplitude)
			* other sounds get mixed in
			* the pulse changes in a different way
		* "synchrony" (runs for a certain amount of time)
			* are people's breathing synchronized OR have we reached the timeout?
				* yes:
					* you see yourself in the glass for a second
					* they start feeling more intense vibration
					* crossfade and bump in amplitude of the heartbeat on the actuator (switches to their own heartbeat)
					* a final sound is triggered with a high amplitude ramp (the end)


# Hierarchical Finite State Machines (HFSM)
Our first scenario implemented in Processing using [Hierarchical Finite State Machines (HFSM)](https://en.wikipedia.org/wiki/UML_state_machine#Hierarchically_nested_states).

Here, the FSM mechanisms needed to be slightly modified as follows.

## Basic behavior
In this prototype, a state machine is represented by a "Canvas". The basic behavior of a Canvas is the same of as in a FSM.

The only difference relies on the tasks associated to the states. Each "State" (the blue circles in our diagram) has a set of Tasks (the red boxes in our diagram). These tasks run in parallel whenever a state is executed. This allows us to easily implement tasks in parallel (for example, a OSC message could be sent at the same time as an audio is played).

Tasks can be so far: a) Audio; b) OSC; and c) Other canvas (which allows us to create hierarchy). More (e.g. MIDI, DMX) can be created by extending the abstract class [Task](Link-ommited-for-anonymization).

## Diagram
This diagram was built as follows:

![image](https://photos-5.dropbox.com/t/2/AABuEFg3XTmS6eCFbhz1vuzD6kYwE8l6eoeGBS7qybms9A/12/152159960/jpeg/32x32/3/1511409600/0/2/screenshot.jpg/EPDEsHQYp_oGIAcoBw/ADe4tGgickrK2lOfOS2Ze7VH681PRRSb7P3oJy4HXmk?dl=0&size=640x480&size_mode=3)

## Usage
After designing the HFSM, three steps are necessary. First you need to run the HFSM in the setup by using:

```java
root.run();
```

Second, you need to update the HFSM status in the draw:

```java
root.update_status();
```

Finally, you need to tick the HFSM whenever you want to feed the structure with an input. The possible inputs are defined in a enumerator called "Input". In the following code, the HFSM receives a new input according to the key pressed:

```java

void keyPressed() {
	Input i;

    switch(key) {
    case '1':
      i = Input.START_MAIN_LOOP;
      break;
    case '2':
      i = Input.START_SELF_APPEARS;
      break;
    case '3':
      i = Input.DATA_SYNCED_OR_TIMEOUT;
      break;
    case '4':
      i = Input.FINISH;
      break;
    }

    root.tick(i);
  }
```

For our first scenario, the defined Inputs are:

```java
public static enum Input {
    START_MAIN_LOOP,
    START_SELF_APPEARS,
    DATA_SYNCED_OR_TIMEOUT,
    FINISH;
}
```

For more details, check the class ["Scenario"](Link ommited for anonymization).

## UI
A simple UI was created as follows:

![image](https://photos-5.dropbox.com/t/2/AADhBo4Q1FXf4ooEuS5NaUIVJWy3yTZGyhslmTGvLRqzOQ/12/152159960/jpeg/32x32/3/1511409600/0/2/state-machine-scenario.jpg/EPDEsHQYp_oGIAcoBw/vEH7yr5e-yTTj0Ga4eaiLpvEsQsBebgwv6JlNCHL26I?dl=0&size=640x480&size_mode=3)

To note:

- Key ' ' executes the demo. The 's' key stops the execution. Keys 'q', 'w', 'e' and 'r' change the input value on the blackboard. Keys '1', '2', and '3' change the state machine which is being currently exhibited;

- A label on the top left represents the State Machine is is being presented in the moment. This label should allow navigation between different state machines (not implemented);

- States are now initialized in a random x/y position, but they can be dragged to whatever position users find convenient;

- Blackboard does not currently support user-defined expressions, but support Java data type. The Blackboard should also be fed according to the received OSC messages. This functionality is not currently implemented;

- Whenever users click on a task, they should see options related to this task (e.g. audio filename and volume to AudioTasks; a previous of the graphics for the sub state machines). This functionality is not currently implemented;

For more info on extended UI possibilities, check [this paper prototype](https://www.dropbox.com/s/gceqio3adg8d5xj/4%20-%20Paper%20prototyping.md).
