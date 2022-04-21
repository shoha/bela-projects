/*******************
Analog Input
Connect analog sources (e.g.: potentiometers, LDR, FSR) to analog input 0 and 1

AnalogIn returns a value from 0-1

.ar (analogPin: 0, mul: 1, add: 0)

analogPin:  Analog pin number to read. Pin numbers begin at 0. This value can be modulated at audiorate.

(c) 2017: Jonathan Reus, Marije Baalman, Giulio Moro, Andrew McPherson
*/

s = Server.default;

s.options.numAnalogInChannels = 2; // can only be 2, 4 or 8
s.options.numAnalogOutChannels = 2;
s.options.numDigitalChannels = 0;
s.options.maxLogins = 4;  	   // set max number of clients
s.options.bindAddress = "0.0.0.0"; // allow anyone on the network connect to this server

s.options.blockSize = 16;
s.options.numInputBusChannels = 2;
s.options.numOutputBusChannels = 2;

s.waitForBoot{
	"Server Booted".postln;

	SynthDef("Equalizer", { |out|
		var in = SoundIn.ar([0, 1]);
		var eqd = in;
		eqd = BPeakEQ.ar(in, 125, 1/1.41, 0);
		eqd = BPeakEQ.ar(eqd, 127, 1/2.53, -15);
		eqd = BPeakEQ.ar(eqd, 133, 1/5.03, -15);
		eqd = BPeakEQ.ar(eqd, 135, 1/1.64, -2);
		eqd = BPeakEQ.ar(eqd, 1000, 1/1.41, 0);
		Out.ar(out, eqd);
	}).play(s);

	s.sync;
};

ServerQuit.add({ 0.exit }); // quit if the button is pressed
