/*
Copyright (c) 2014, Steven Presser
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

//General settings
printheadRadius=14; //The size of the center of the torus - where the printhead goes
fanSize=40; // We assume a square fan.  The length of one side of the square
ductRadius=9; //How big is the torus surrounding the printhead?  This is the hoizontal length and 1/2 the vertical height
outletGap=4.55; //How wide the gap on the bottom of the torus is to release air
wallThickness=0.7; //How thick are all of the walls in this model?

// The attachment is the part you use to mount the duct to the printer.  The fan sits on top
attachHeight=60; //How tall is the portion where the fan mounts?
attachYOffset=0; //allows you to move the attachment along the y axis to center the duct
attachXOffset=4.5; //allows you to move the SCReW HOLE along the x axis to center the duct

// These control things about the wall which actually gets screwed into the printer
mountScrewWidth=3; //How wide is the hole?
mountThickness=3; //How thick is that wall?  For thermal protection (the walls melt if they're too thin) this should be enough that when sliced there is internal support structure.

//Fan mount details
fanMountWidth=7.4; //how much extra to add at the edges for mounts, hole automagically placed halfway
fanMountHole=1.7; //radius of the screw hole
fanMountDepth=10; //depth of screw hole

// Magic variable to keep us 'simple'.  Should make no appreciable changes in the model.  Reduce if so desired.
fudge=0.01;

if (fanSize>attachHeight) {
	echo("WARNING: fan size is greater than attachHeight.  Model will not be 45-degree rule compatible");
}

module roundDuct(ductRadius) {
	polygon(points=[[0,0],[0,2*ductRadius],[ductRadius,ductRadius],[ductRadius,0]]);
}

module fanScrewMount () {
	rotate([0,-90,0]) 
		linear_extrude(height=fanMountWidth) polygon(points=[
			[0,0],
			[fanMountWidth,0],
			[fanMountWidth,fanMountWidth],
		]);
}

//The printhead we're doing all this around
//color("red") cylinder(r=printheadRadius,h=attachHeight);

// We'll cut parts out after we make the whole thing
difference() {
	//do the making
	union() {
		// stuff around the printhead
		rotate_extrude() translate([printheadRadius,0,0]) roundDuct(ductRadius);
		//fan mount
		translate([fanSize/2,printheadRadius,0]) rotate([0,-90,0]) linear_extrude(height=fanSize)
			polygon(points=[
				[0,max(attachYOffset,0)],
				[attachHeight,max(attachYOffset,0)],
				[attachHeight,fanSize+max(attachYOffset,0)+mountThickness-wallThickness],
				[0,max(ductRadius,ductRadius+attachYOffset)+mountThickness-wallThickness]]
			);
		//hull to make them attach sanely
		// ceter part cut later
		hull () {
			rotate_extrude() translate([printheadRadius,0,0]) roundDuct(ductRadius);
			rotate([0,90,90]) translate([0,-fanSize/2,max(printheadRadius,printheadRadius+attachYOffset)]) rotate([0,0,90]) linear_extrude(height=0.1) polygon(points=[
					[0,0],
					[fanSize,0],
					[fanSize,2*ductRadius],
					[fanSize/2,4*ductRadius],
					[0,2*ductRadius]
					]
			);
		}
		if (attachYOffset<0) {
			translate([-fanSize/2,printheadRadius+attachYOffset,0]) cube([fanSize,max(mountThickness, -attachYOffset+wallThickness), attachHeight]);
		}
	}
	// center for printhead
	cylinder(r=printheadRadius+fudge,h=4*ductRadius);
	translate([0,0,4*ductRadius]) cylinder(r1=printheadRadius,r2=0,h=printheadRadius);

	//fan
	translate([fanSize/2-wallThickness,printheadRadius-fudge,0]) difference() {
		rotate([0,-90,0]) linear_extrude(height=fanSize-2*wallThickness) 
			polygon(points=[
				[wallThickness,max(attachYOffset,0)+mountThickness],
				[attachHeight+fudge,max(attachYOffset,0)+mountThickness],
				[attachHeight+fudge,fanSize-2*wallThickness+max(attachYOffset,0)+mountThickness],
				[wallThickness,max(ductRadius, ductRadius+attachYOffset)+mountThickness-wallThickness],
		]);
		translate([0,mountThickness+max(attachYOffset,0),attachHeight-fanMountWidth]) fanScrewMount();
		translate([-fanSize+2*wallThickness+fanMountWidth,max(attachYOffset,0)+mountThickness,attachHeight-fanMountWidth]) fanScrewMount();
		translate([-fanMountWidth,fanSize-fanMountWidth-2*wallThickness+max(attachYOffset,0)+mountThickness,0]) cube([fanMountWidth,fanMountWidth,attachHeight]);
		translate([-fanSize+2*wallThickness,fanSize-fanMountWidth-2*wallThickness+max(attachYOffset,0)+mountThickness,0]) cube([fanMountWidth,fanMountWidth,attachHeight]);
	}
	
	// this one is complicated, we only want to make cuts that are not covered by the duct itself.
	// empty space in the duct
	difference() {
		hull () {
			rotate_extrude() translate([printheadRadius+wallThickness,wallThickness,0]) roundDuct(ductRadius-2*wallThickness);
			rotate([0,90,90]) translate([-wallThickness,-fanSize/2+wallThickness,max(printheadRadius,printheadRadius+attachYOffset)]) rotate([0,0,90]) linear_extrude(height=wallThickness) polygon(points=[
					[0,0],
					[fanSize-2*wallThickness,0],
					[fanSize-2*wallThickness,2*ductRadius-2*wallThickness],
					[fanSize/2-wallThickness,4*ductRadius-2*wallThickness],
					[0,2*ductRadius-2*wallThickness]
					]
			);
		}
		cylinder(r=printheadRadius+wallThickness,h=4*ductRadius);
	}
	#rotate([0,90,90]) translate([-wallThickness,-fanSize/2+wallThickness,max(printheadRadius+wallThickness,printheadRadius+attachYOffset+wallThickness)]) rotate([0,0,90]) linear_extrude(height=mountThickness-wallThickness) polygon(points=[
			[0,0],
			[fanSize-2*wallThickness,0],
			[fanSize-2*wallThickness,2*ductRadius-2*wallThickness],
			[fanSize/2-wallThickness,4*ductRadius-2*wallThickness],
			[0,2*ductRadius-2*wallThickness]
			]
		);

	//duct inners
	rotate_extrude() translate([printheadRadius+wallThickness-fudge,wallThickness,0]) roundDuct(ductRadius-2*wallThickness);
	//gap to let air out
	translate([0,0,-fudge]) difference() {
		cylinder(r=printheadRadius+wallThickness+outletGap,h=wallThickness+2*fudge);
		cylinder(r=printheadRadius+wallThickness,h=wallThickness+2*fudge);
	}
	
	//screw slot to mount block
	translate([attachXOffset,-2*fudge+attachYOffset,0]) hull() {
		#translate([-mountScrewWidth/2, printheadRadius,4*ductRadius+mountScrewWidth]) rotate([0,45,0]) cube([mountScrewWidth/sqrt(2),max(mountThickness,-attachYOffset+wallThickness)+4*fudge,mountScrewWidth/sqrt(2)]);
		translate([-mountScrewWidth/2, printheadRadius,attachHeight-mountScrewWidth]) rotate([0,45,0]) cube([mountScrewWidth/sqrt(2),max(mountThickness,-attachYOffset+wallThickness)+4*fudge,mountScrewWidth/sqrt(2)]);
	}
	
	//screw holes for mounting fan
	#translate([fanSize/2,printheadRadius-fudge+max(attachYOffset,0)+mountThickness-wallThickness,0]) {
		translate([-wallThickness-fanMountWidth/2,wallThickness+fanMountWidth/2,attachHeight-fanMountDepth]) cylinder(r=fanMountHole,h=fanMountDepth);
		translate([wallThickness+fanMountWidth/2-fanSize,wallThickness+fanMountWidth/2,attachHeight-fanMountDepth]) cylinder(r=fanMountHole,h=fanMountDepth);
		translate([-wallThickness-fanMountWidth/2,-wallThickness-fanMountWidth/2+fanSize,attachHeight-fanMountDepth]) cylinder(r=fanMountHole,h=fanMountDepth);
		translate([wallThickness+fanMountWidth/2-fanSize,-wallThickness-fanMountWidth/2+fanSize,attachHeight-fanMountDepth]) cylinder(r=fanMountHole,h=fanMountDepth);
	}
}