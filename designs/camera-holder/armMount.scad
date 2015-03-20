/*

Copyright (c) 2014, Steven Presser
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither Steven Presser nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

gapThick=8;
acryThick=5.6;
armThick=40;
armHeight=20;
armBackHeight=7;

wallThickness=3;
width=40;

beamLength=120;
beamThick=5;
beamHeight=20;

union() {
	cube([gapThick+acryThick+armThick+(2*wallThickness), width, wallThickness]);
	translate([0,0,wallThickness]) cube([wallThickness, width, armBackHeight]);
	translate([wallThickness+armThick,0,wallThickness]) cube([gapThick, width, armHeight]);
	translate([wallThickness+armThick+acryThick+gapThick,0,wallThickness]) cube([wallThickness, width, armHeight]);
	
	translate([(2*wallThickness)+armThick+acryThick+gapThick,width/2-beamThick/2,0]) {
		cube([beamLength+beamHeight, beamThick, beamThick]);
		translate([0,0, beamHeight-beamThick]) cube([beamLength+beamHeight, beamThick, beamThick]);
		for (x = [0:beamHeight-beamThick:beamLength+beamHeight]) {
			translate([x,0,0]) cube([beamThick,beamThick,beamHeight]);
		}
	}
}