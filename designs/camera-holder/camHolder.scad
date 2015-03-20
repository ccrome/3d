/*

Copyright (c) 2014, Steven Presser
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither Steven Presser nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

*/

dropDistance=100;
splitWidth=45;
beamThickness=5;
tongueLength=30;

union() {
	cube([2*beamThickness,beamThickness,2*beamThickness]);
	translate([beamThickness,beamThickness,0])
cube([beamThickness,2*beamThickness,beamThickness]);
	translate([0,2*beamThickness,0]) cube([2*beamThickness,beamThickness,2*beamThickness]);
	translate([0,2*beamThickness,0]) {
		cube([beamThickness, dropDistance, beamThickness]);
	}
	translate([-(splitWidth-beamThickness)/2,2*beamThickness+dropDistance,0]) {
		cube([splitWidth, beamThickness, beamThickness]);
		cube([beamThickness, beamThickness, tongueLength]);
		translate([splitWidth-beamThickness,0,0]) cube([beamThickness, beamThickness, tongueLength]);
	}
}