## Logic Networks Final Project
This is a final project for the Logic Networks course at Politecnico di Milano for the 2022/2023 academic year. The project, which centers on the implementation of a hardware module described in `VHDL` interfacing with a memory, earned me a score of 28/30.

## Problem Description
At a high level of abstraction, the system receives information about a memory location, the content of which must be directed to one of the four available output channels. Instructions regarding the channel to be used and the memory address to access are provided through a one-bit serial input, while the system's outputs, deliver all the bits of the memory word in parallel.

In more detalils the module, after a reset, initializes the outputs. The input receives a sequence, structured with a 2 header bits that identify the output channel, followed by bits for the memory address, padded with 0 when necessary. The bits are read on the rising edge of the clock. The input is valid when the `START` signal is equals to 1 and concludes with `START` is equals to 0, lasting from 2 to 18 clock cycles. The outputs remain at 0 until a message is read and are only visible when the `DONE` signal is equals to 1. When `DONE` is equals to 1, the channel displays the message, while the other channels display the last transmitted value. `START` will remain at 0 until `DONE` reverts to 0. The result must occur within 20 clock cycles.

## My implementation
The implementation I proposed is a VHDL module based on a Mealy finite state machine (FSM) controlled by the clock, start, and reset signals. The FSM manages the processing and routing of messages within the communication system. Below, the functional architecture of the system is presented with an image of the FSM (Figure 1), a table (Figure 3) illustrating the Output Logic with the vector values varying according to the state of the FSM, and another table (Figure 2) representing the next state logic.

For those interested in a more detailed breakdown of my solution, an official relation in Italian detailing the structure of the bot is available in this repository as 'official_relation.pdf'.
