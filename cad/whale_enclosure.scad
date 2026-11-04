// Whale Listener enclosure - PARAMETRIC CONCEPT, not a verified waterproof design
// OpenSCAD. Units mm. Print body open-side up; lid flat.
// Export by setting part = "body", "lid", or "gasket_template".
// Do not install electronics until fit, leak and battery safety tests pass.
$fn=64;
part="assembly"; // body | lid | gasket_template | assembly
L=130; W=75; body_h=24.8; lid_t=4;
corner_r=9; wall=3; floor_t=3;
gasket_t=1.5; compressed_gap=1.2; // 20% nominal compression
seal_outer_inset=9; seal_inner_inset=15; // 6 mm wide planar sealing land
cavity_inset=17; // 96 x 41 mm cavity, conservative for gasket + screw separation
screw_d=3.4; screw_pilot_d=2.5; screw_depth=9;
gland_pilot=false; // actual 1/4 NPT gland geometry MUST be measured
gland_hole_d=10; // PLACEHOLDER ONLY, not an NPT tapping specification
function rmax(a,b)=a>b?a:b;
module rr(l,w,r){offset(r=r) square([l-2*r,w-2*r],center=true);}
module shape2d(inset){rr(L-2*inset,W-2*inset,rmax(0.8,corner_r-inset));}
screws=[
 [-56,-28.5],[-56,28.5],[56,-28.5],[56,28.5],
 [0,-32.5],[0,32.5],[-59,0],[59,0]
];
module screw_holes(d,h,z){for(p=screws)translate([p[0],p[1],z])cylinder(d=d,h=h);}
module body(){
 difference(){
  linear_extrude(body_h)shape2d(0);
  translate([0,0,floor_t])linear_extrude(body_h-floor_t+0.1)shape2d(cavity_inset);
  // blind pilots in body rim; ensure minimum material thickness
  screw_holes(screw_pilot_d,screw_depth,body_h-screw_depth);
  // Optional pilot only; machine or design gland opening to measured gland datasheet
  if(gland_pilot)translate([0,-W/2-0.1,body_h/2])
     rotate([-90,0,0])cylinder(d=gland_hole_d,h=wall+2);
 }
}
module lid(){
 difference(){
  linear_extrude(lid_t)shape2d(0);
  screw_holes(screw_d,lid_t+0.2,-0.1);
 }
}
module gasket2d(){difference(){shape2d(seal_outer_inset);shape2d(seal_inner_inset);}}
module gasket_template(){linear_extrude(0.5)gasket2d();}
if(part=="body")body();
else if(part=="lid")lid();
else if(part=="gasket_template")gasket_template();
else {
 color("teal")body();
 translate([0,0,body_h+compressed_gap])color("silver")lid();
 translate([0,0,body_h])color("orange",0.7)linear_extrude(compressed_gap)gasket2d();
}
