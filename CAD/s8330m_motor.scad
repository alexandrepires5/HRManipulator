include <general.scad>

/* ------ s8330m ------ */
//servo dimensions
s8330m_total_height = 57;
s8330m_length = 59;
s8330m_partial_height = 48;
s8330m_width = 29; //D
s8330m_total_length = 74;
s8330m_height = 39;
s8330m_length_to_shaft = 12;

s8330m_bottom_cylinder_diameter = 0.384*s8330m_width; //sleeve
//s8330m_bottom_cylinder_height = 4.8; //sleeve
s8830m_bottomhinge_hole = s8330m_bottom_cylinder_diameter+0.4;

//servo_fixation_holes
s8330m_fixation_hole_x = 5;
s8330m_fixation_hole_y = 0;
s8330m_fixation_hole_z = 8.25;
s8330m_hole_diameter = 2.5;

//horn
s8330m_horn_height = 4;
s8330m_horn_1stcircle = 10;
s8330m_horn_2ndcircle = 15;
s8330m_horn_length = 34.5;
s8330m_horn_bigscrew = 10;
s8330m_horn_smallscrew = 2;
s8330m_horn_smallscrew_length =17;
s8330m_horn_head_d1 = 2;
s8330m_horn_head_d2 = 4;
    
/* ----------------------------- */

/* ------ if base_servo == "s8330m" ------*/
//hinge
support_z_hinge = s8330m_width + 0.9;
support_width_hinge = (s8330m_total_length - s8330m_length)/2 + 3;
servo_axis_clear = (s8330m_horn_length -s8330m_horn_1stcircle/2 + 3);
servo_HTot = s8330m_total_height + 2; //A
bigscrew = s8330m_horn_bigscrew;
smallscrew = s8330m_horn_smallscrew;
smallscrew_length = s8330m_horn_smallscrew_length;
smallscrew_head_d1 = s8330m_horn_head_d1;
smallscrew_head_d2 = s8330m_horn_head_d2;
//sleeve
support_width_sleeve = (s8330m_total_length - s8330m_length)/2 + 3;
servo_L = s8330m_length + 0.9;
servo_H = s8330m_height + 0.5;
support_z_sleeve = s8330m_width + 0.9;
servo_bottom_cylinder_diameter = s8330m_bottom_cylinder_diameter;
//servo_fixation_holes
servo_fixation_hole_x = s8330m_fixation_hole_x ;
servo_fixation_hole_y = s8330m_fixation_hole_y ;
servo_fixation_hole_z = s8330m_fixation_hole_z ;
servo_hole_diameter = 2;

/* ----------------------------- */
sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
sleeve_hinge_size = sleeve_hinge_dist*2;
hinge_sleeve_dist = 5;
hanger_height = support_width_hinge + 0.3;

module motor(){
    cube(size = [29,59,50], center = true);
    translate([0,0,39/2]) 
        cube(size = [29,74,11], center = true);
    translate([0,s8330m_length*1/2-4.5,s8330m_partial_height/2]) rotate([0,0,$t*180]) 
        cylinder(d=s8330m_horn_1stcircle*2/3, h=7);     
    translate([0,s8330m_length*1/2-4.5,57/2]) rotate([0,0,$t*180])
        horn_single("s8330m");
}

motor();