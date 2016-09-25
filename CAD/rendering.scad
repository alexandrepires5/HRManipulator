include <measures.scad>
include <motor.scad>
include <horn.scad>

/* ------ if base_servo == "s8330m" ------*/
//hinge
support_z_hinge = s8330m_width + 0.9;
support_width_hinge = (s8330m_total_length - s8330m_length)/2 + 3;
servo_axis_clear = (s8330m_horn_length -s8330m_horn_1stcircle/2 + 3);
servo_HTot = s8330m_total_height + 0.5; //A
bigscrew = s8330m_horn_bigscrew;
smallscrew = s8330m_horn_smallscrew;
smallscrew_length = s8330m_horn_smallscrew_length;
smallscrew_head_d1 = s8330m_horn_head_d1;
smallscrew_head_d2 = s8330m_horn_head_d2;
//sleeve
support_width_sleeve = (s8330m_total_length - s8330m_length)/2 + 3;
servo_L = s8330m_length + 0.9;
servo_H = s8330m_height + 1;
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

module generic_screw(d = 3, h = 10, head_h = 1, head_top_d = 5, head_bot_d = 3, thread = 0) {
    union() {
        translate([0, 0, -h])
        cylinder(d = d - thread, h = h);
        translate([0, 0, -head_h])
        cylinder(h = head_h + 1e-3, d1 = max(d, head_bot_d), d2 = head_top_d);
    }
}

module M25_screw_hole(h = 10) {
  generic_screw(h = h, d = 2.9, head_top_d = 4,  head_bot_d = 2.5);   
}

module plate() {
    difference() {
        translate([0, 0, -3/2])
        cube([18, 12, 3], center = true);
        
        translate([-6, -3, 0])
        M25_screw_hole(); 
        translate([-6,  3, 0])
        M25_screw_hole(); 
        translate([6, -3, 0])
        M25_screw_hole(); 
        translate([6,  3, 0])
        M25_screw_hole(); 
    }
}

module servo_sleeve_s8330m(type = "side_hole", hole = "one"){
 
    union(){
	  difference(){
	    linear_extrude(height = support_z_sleeve, center = true)
	    polygon( points=[[0,0],
	                 [support_width_sleeve, 0],
	                 [support_width_sleeve, -(servo_H + support_width_sleeve)],
	                 [-servo_L - support_width_sleeve, -(servo_H + support_width_sleeve)],
	                 [-servo_L - support_width_sleeve, 0],
	                 [-servo_L, 0],
	                 [-servo_L, -servo_H],
	                 [0, -servo_H]
	                ]);
	    // Servo fixation hole
	    translate([servo_fixation_hole_x, servo_fixation_hole_y, servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - servo_fixation_hole_x, servo_fixation_hole_y, servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
        if(hole == "two")
        {
            // Servo fixation hole
	    translate([servo_fixation_hole_x, servo_fixation_hole_y, -servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - servo_fixation_hole_x, servo_fixation_hole_y, -servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
        }
        
        // Servo cable carving (side start)
	    translate([-servo_L - 2, -servo_H - 3.4 + 1e-3, -4.2/2])
	    #cube([support_width_sleeve, 7 + 8, 4.1]);
	
        if(type == "side_hole"){
  	      // Servo cable carving
	      translate([-servo_L, -3.4 - servo_H, -4.2/2])
	      cube([servo_L + support_width_sleeve, 3.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-10, -1.0 - servo_H, -3.2/2])
	      cube([servo_L + support_width_sleeve, 9, 3.2]);
        } else { // bottom_hole
  	      // Servo cable carving
	      translate([-servo_L, -3.4 - servo_H, -4.2/2])
	      cube([servo_L, 3.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-9, -1.5 * support_width_sleeve - servo_H, -3.2/2])
	      cube([8.9, 2 * support_width_sleeve, 3.2]);
        }
	  }
	
	  // Servo hinge
	  translate([-servo_L + 13,  -(servo_H + support_width_sleeve), 0])
	  rotate([90, 0, 0])
	  cylinder(d = servo_bottom_cylinder_diameter, h = support_width_hinge-1, $fn =32);
	
	}
}


module servo_hinge_s8330m(hinge_servo = "s8330m"){

	difference(){
        union(){
            
          linear_extrude(height = support_z_hinge, center = true)
            polygon( points=[
	                 [support_width_hinge, 0],
	                 [0, 0],
	                 [0, servo_axis_clear],
	                 [-servo_HTot - support_width_sleeve, servo_axis_clear],
	                 [-servo_HTot - support_width_sleeve, 0],
	                 [-servo_HTot - support_width_sleeve - support_width_hinge, 0],
	                 [-servo_HTot - support_width_sleeve - support_width_hinge, support_width_hinge + servo_axis_clear],
	                 [support_width_hinge, support_width_hinge + servo_axis_clear]
	                ]);

          // Round end
          for(i = [0:1]){
              translate([i*(-servo_HTot - support_width_sleeve - support_width_hinge), 0, 0]) rotate([0, 90, 0])
                cylinder(d = support_z_hinge, h = support_width_hinge, $fn = 32);
          }
        
        }
        union(){
            // Horn Big screw
            translate([-support_width_hinge/2, 0, 0]) rotate([0, 90, 0])
            cylinder(d = bigscrew, h = 2*support_width_hinge, $fn =32);

            // Horn Small screw
            translate([-support_width_hinge/2, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                cylinder(d = smallscrew, h = 2*support_width_hinge, $fn =32);
        
            // Horn Small screw head
            translate([support_width_hinge - 1.7, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                cylinder(d1 = smallscrew_head_d1, d2 = smallscrew_head_d2, h = 2*support_width_hinge, $fn =32);
        

            // Horn
            translate([-2, 0, 0]) rotate([90, 0, 90]) 
                horn_s8330m();
	
            // Bottom hinge hole
            translate([-servo_HTot - 2.5*support_width_hinge, 0, 0])
            rotate([0, 90, 0])
                color() cylinder(d = s8830m_bottomhinge_hole, h = 2*support_width_hinge, $fn =32);
	  }
	
	}

}

module sleeve_hinge_s8330m(screw){
  difference(){
      union(){
         translate([-sleeve_hinge_size/2+2 + support_width_sleeve, -sleeve_hinge_dist/2 - servo_H - support_width_sleeve, 0])
  cube([sleeve_hinge_size-4, sleeve_hinge_dist + 2, support_z_sleeve], center = true);

  translate([0, -servo_axis_clear - servo_H - 2 * support_width_hinge - sleeve_hinge_dist, 0]) 
    servo_hinge_s8330m();
    
  if(screw == "one") servo_sleeve_s8330m(type = "side_hole", hole = "one");
      else servo_sleeve_s8330m(type = "side_hole", hole = "two");
     }
       /*   
      // 1st screw
      
	    translate([-(sleeve_hinge_size - max(support_width_sleeve, support_width_hinge))/3, -servo_axis_clear - servo_H - 2 * support_width_hinge - 2*sleeve_hinge_dist, 0])
	    rotate([0, 90, 90]) 
	    #cylinder(d = 2.5, h = 100, $fn =32);
      // 2nd screw
	    translate([-(sleeve_hinge_size - max(support_width_sleeve, support_width_hinge))*2/3, -servo_axis_clear - servo_H - 2 * support_width_hinge - 2*sleeve_hinge_dist, 0])
	    rotate([0, 90, 90]) 
	    #cylinder(d = 2.5, h = 100, $fn =32);*/
  }
  
}


module hinge_sleeve_alt_sleeve_s8330m(screw){
  difference(){
    union(){
  
      translate([-15.5*abs(servo_axis_clear-servo_H), -servo_L, 0])
      rotate([0, 0, -90])
        if(screw == "one") servo_sleeve_s8330m(type = "bottom", hole = "one");
        else servo_sleeve_s8330m(type = "bottom_hole", hole = "two");
    }
    
    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - 1.5 * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-13/16.5*servo_H, -servo_L - 1.5 * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-13/16.5*servo_H, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
  }
}





module servo_sleeve_mg946r(type = "side_hole", hole = "two"){
    
    support_width_sleeve = (mg946r_total_length - mg946r_length)/2 + 2;
    servo_L = mg946r_length + 0.9;
    servo_H = mg946r_height + 0.5;
    servo_fixation_hole_x = mg946r_fixation_hole_x ;
    servo_fixation_hole_y = mg946r_fixation_hole_y ;
    servo_fixation_hole_z = mg946r_fixation_hole_z ;
    servo_hole_diameter = 2;
    support_z_sleeve = mg946r_width + 0.25;
    servo_bottom_cylinder_diameter = mg946r_bottom_cylinder_diameter;
    support_width_hinge = (mg946r_total_length - mg946r_length)/2 + 2;
    
    union(){
	  difference(){
	    linear_extrude(height = support_z_sleeve, center = true)
	    polygon( points=[[0,0],
	                 [support_width_sleeve, 0],
	                 [support_width_sleeve, -(servo_H + support_width_sleeve)],
	                 [-servo_L - support_width_sleeve, -(servo_H + support_width_sleeve)],
	                 [-servo_L - support_width_sleeve, 0],
	                 [-servo_L, 0],
	                 [-servo_L, -servo_H],
	                 [0, -servo_H]
	                ]);
	    // Servo fixation hole
	    translate([servo_fixation_hole_x, servo_fixation_hole_y, servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - servo_fixation_hole_x, servo_fixation_hole_y, servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
        if(hole == "two")
        {
            // Servo fixation hole
	    translate([servo_fixation_hole_x, servo_fixation_hole_y, -servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - servo_fixation_hole_x, servo_fixation_hole_y, -servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
        }
        
        // Servo cable carving (side start)
	    translate([-servo_L - 1.4, -servo_H - 1.4 + 1e-3, -4.2/2])
	    cube([support_width_sleeve, 7 + 1.4, 4.2]);
	
        if(type == "side_hole"){
  	      // Servo cable carving
	      translate([-servo_L, -1.4 - servo_H, -4.2/2])
	      cube([servo_L + support_width_sleeve, 1.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-10, -1.0 - servo_H, -3.2/2])
	      cube([servo_L + support_width_sleeve, 9, 3.2]);
        } else { // bottom_hole
  	      // Servo cable carving
	      translate([-servo_L, -1.4 - servo_H, -4.2/2])
	      cube([servo_L, 1.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-9, -1.5 * support_width_sleeve - servo_H, -3.2/2])
	      cube([9, 2 * support_width_sleeve, 3.2]);
        }
	  }
	
	  // Servo hinge
	  //translate([-servo_L + 4.5,  -(servo_H + support_width_sleeve), 0])
      translate([-servo_L + 8,  -(servo_H + support_width_sleeve), 0])
	  rotate([90, 0, 0])
	  cylinder(d = servo_bottom_cylinder_diameter, h = support_width_hinge-1, $fn =32);
	
	}

}


module servo_hinge_mg946r(hinge_servo = "mg946r"){
    support_width_sleeve = (mg946r_total_length - mg946r_length)/2 + 2;
    support_z_hinge = mg946r_width + 0.25;
    support_width_hinge = (mg946r_total_length - mg946r_length)/2 + 2;
    servo_axis_clear = (mg946r_horn_length -mg946r_horn_1stcircle/2 + 3);
    servo_HTot = mg946r_total_height + 0.5; //A
    bigscrew = mg946r_horn_bigscrew;
    smallscrew = mg946r_horn_smallscrew;
    smallscrew_length = mg946r_horn_smallscrew_length;
    smallscrew_head_d1 = mg946r_horn_head_d1;
    smallscrew_head_d2 = mg946r_horn_head_d2;
	difference(){
        union(){
            
          linear_extrude(height = support_z_hinge, center = true)
            polygon( points=[
	                 [support_width_hinge, 0],
	                 [0, 0],
	                 [0, servo_axis_clear],
	                 [-servo_HTot - support_width_sleeve, servo_axis_clear],
	                 [-servo_HTot - support_width_sleeve, 0],
	                 [-servo_HTot - support_width_sleeve - support_width_hinge, 0],
	                 [-servo_HTot - support_width_sleeve - support_width_hinge, support_width_hinge + servo_axis_clear],
	                 [support_width_hinge, support_width_hinge + servo_axis_clear]
	                ]);

          // Round end
          for(i = [0:1]){
              translate([i*(-servo_HTot - support_width_sleeve - support_width_hinge), 0, 0]) rotate([0, 90, 0])
                cylinder(d = support_z_hinge, h = support_width_hinge, $fn = 32);
          }
        
        }
        union(){
            // Horn Big screw
            translate([-support_width_hinge/2, 0, 0]) rotate([0, 90, 0])
            #cylinder(d = bigscrew, h = 2*support_width_hinge, $fn =32);

            // Horn Small screw
            translate([-support_width_hinge/2, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                cylinder(d = smallscrew, h = 2*support_width_hinge, $fn =32);
        
            // Horn Small screw head
            translate([support_width_hinge - 1.7, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                #cylinder(d1 = smallscrew_head_d1, d2 = smallscrew_head_d2, h = 2*support_width_hinge, $fn =32);
        

            // Horn
            translate([-2, 0, 0]) rotate([90, 0, 90]) 
                horn_mg946r();
	
            // Bottom hinge hole
            translate([-servo_HTot - 2.5*support_width_hinge, 0, 0])
            rotate([0, 90, 0])
                #cylinder(d = mg946r_bottomhinge_hole, h = 2*support_width_hinge, $fn =32);
	  }
	
	}

}

module hinge_sleeve_alt_hinge_mg946r(screw){

    difference(){
    union(){
      translate([-17.1*abs(servo_axis_clear-servo_H), -servo_L - 2 * support_width_sleeve - hinge_sleeve_dist, 0]) rotate([0, 0, 90]) servo_hinge_mg946r();  
    }

    for (i = [0:1]){
    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - (i+0.5) * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-13/16.5*servo_H, -servo_L - (i+0.5) * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
    }
  }
}


module hinge_sleeve_alt_sleeve_mg946r(screw){
    servo_axis_clear = (mg946r_horn_length - mg946r_horn_1stcircle/2 + 3);
    support_width_hinge = (mg946r_total_length - mg946r_length)/2 + 2;
    support_width_sleeve = (mg946r_total_length - mg946r_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = mg946r_length + 0.9;
    servo_H = mg946r_height + 0.5;
    support_z_sleeve = mg946r_width + 0.25;
    servo_axis_clear = (mg946r_horn_length - mg946r_horn_1stcircle/2 + 3); 
    
  difference(){
    union(){
  
      translate([-15.5*abs(servo_axis_clear-servo_H), -servo_L, 0])
      rotate([0, 0, -90])
        if(screw == "one") servo_sleeve_mg946r(type = "bottom", hole = "one");
        else servo_sleeve_mg946r(type = "bottom_hole", hole = "two");
    }
    
//    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - 1.5 * support_width_sleeve - hinge_sleeve_dist, 0])
//    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
//
//    translate([-17.1*abs(servo_axis_clear-servo_H)-13/16.5*servo_H, -servo_L - 1.5 * support_width_sleeve - hinge_sleeve_dist, 0])
//    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
//
    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-13/16.5*servo_H, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
    
    }
}


module sleeve_hinge_mg946r(screw){
    support_width_hinge = (mg946r_total_length - mg946r_length)/2 + 2;
    support_width_sleeve = (mg946r_total_length - mg946r_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = mg946r_length + 0.9;
    servo_H = mg946r_height + 0.5;
    support_z_sleeve = mg946r_width + 0.25;
    servo_axis_clear = (mg946r_horn_length -mg946r_horn_1stcircle/2 + 3);
    
    difference(){
      union(){
         translate([-sleeve_hinge_size/2+2 + support_width_sleeve, -sleeve_hinge_dist/2 - servo_H - support_width_sleeve, 0])
  cube([sleeve_hinge_size-6, sleeve_hinge_dist + 2, support_z_sleeve], center = true);

  translate([0, -servo_axis_clear - servo_H - 2 * support_width_hinge - sleeve_hinge_dist, 0]) 
    servo_hinge_mg946r();
    
  if(screw == "one") servo_sleeve_mg946r(type = "side_hole", hole = "one");
      else servo_sleeve_mg946r(type = "side_hole", hole = "two");
     }
       /*   
      // 1st screw
      
	    translate([-(sleeve_hinge_size - max(support_width_sleeve, support_width_hinge))/3, -servo_axis_clear - servo_H - 2 * support_width_hinge - 2*sleeve_hinge_dist, 0])
	    rotate([0, 90, 90]) 
	    #cylinder(d = 2.5, h = 100, $fn =32);
      // 2nd screw
	    translate([-(sleeve_hinge_size - max(support_width_sleeve, support_width_hinge))*2/3, -servo_axis_clear - servo_H - 2 * support_width_hinge - 2*sleeve_hinge_dist, 0])
	    rotate([0, 90, 90]) 
	    #cylinder(d = 2.5, h = 100, $fn =32);*/
  }
  
}


module servo_sleeve_hk15328(type = "side_hole", hole = "two"){
    
    support_width_sleeve = (hk15328_total_length - hk15328_length)/2 + 2;
    servo_L = hk15328_length + 0.9;
    servo_H = hk15328_height;
    servo_fixation_hole_x = hk15328_fixation_hole_x ;
    servo_fixation_hole_y = hk15328_fixation_hole_y ;
    servo_fixation_hole_z = hk15328_fixation_hole_z ;
    servo_hole_diameter = 2;
    support_z_sleeve = hk15328_width + 0.25;
    servo_bottom_cylinder_diameter = hk15328_bottom_cylinder_diameter;
    support_width_hinge = (hk15328_total_length - hk15328_length)/2 + 2;
    
    union(){
	  difference(){
	    linear_extrude(height = support_z_sleeve, center = true)
	    polygon( points=[[0,0],
	                 [support_width_sleeve, 0],
	                 [support_width_sleeve, -(servo_H + support_width_sleeve)],
	                 [-servo_L - support_width_sleeve, -(servo_H + support_width_sleeve)],
	                 [-servo_L - support_width_sleeve, 0],
	                 [-servo_L, 0],
	                 [-servo_L, -servo_H],
	                 [0, -servo_H]
	                ]);
	    // Servo fixation hole
	    translate([servo_fixation_hole_x, servo_fixation_hole_y, servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - servo_fixation_hole_x, servo_fixation_hole_y, servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
        if(hole == "two")
        {
            // Servo fixation hole
	    translate([servo_fixation_hole_x, servo_fixation_hole_y, -servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - servo_fixation_hole_x, servo_fixation_hole_y, -servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
        }
        
        // Servo cable carving (side start)
	    translate([-servo_L - 1.4, -servo_H - 1.4 + 1e-3, -4.2/2])
	    cube([support_width_sleeve, 7 + 1.4, 4.2]);
	
        if(type == "side_hole"){
  	      // Servo cable carving
	      translate([-servo_L, -1.4 - servo_H, -4.2/2])
	      cube([servo_L + support_width_sleeve, 1.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-10, -1.0 - servo_H, -3.2/2])
	      cube([servo_L + support_width_sleeve, 9, 3.2]);
        } else { // bottom_hole
  	      // Servo cable carving
	      translate([-servo_L, -1.4 - servo_H, -4.2/2])
	      cube([servo_L, 1.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-9, -1.5 * support_width_sleeve - servo_H, -3.2/2])
	      cube([9, 2 * support_width_sleeve, 3.2]);
        }
	  }
	
	  // Servo hinge
	  //translate([-servo_L + 4.5,  -(servo_H + support_width_sleeve), 0])
      translate([-servo_L + 10.45,  -(servo_H + support_width_sleeve), 0])
	  rotate([90, 0, 0])
	  cylinder(d = servo_bottom_cylinder_diameter, h = support_width_hinge-1, $fn =32);
	
	}

}


module servo_hinge_hk15328(hinge_servo = "hk15328"){
    support_width_sleeve = (hk15328_total_length - hk15328_length)/2 + 2;
    support_z_hinge = hk15328_width + 0.25;
    support_width_hinge = (hk15328_total_length - hk15328_length)/2 + 2;
    servo_axis_clear = (hk15328_horn_length -hk15328_horn_1stcircle/2 + 7);
    servo_HTot = hk15328_total_height + 2; //A
    bigscrew = hk15328_horn_bigscrew;
    smallscrew = hk15328_horn_smallscrew;
    smallscrew_length = hk15328_horn_smallscrew_length;
    smallscrew_head_d1 = hk15328_horn_head_d1;
    smallscrew_head_d2 = hk15328_horn_head_d2;
	difference(){
        union(){
            
          linear_extrude(height = support_z_hinge, center = true)
            polygon( points=[
	                 [support_width_hinge, 0],
	                 [0, 0],
	                 [0, servo_axis_clear],
	                 [-servo_HTot - support_width_sleeve, servo_axis_clear],
	                 [-servo_HTot - support_width_sleeve, 0],
	                 [-servo_HTot - support_width_sleeve - support_width_hinge, 0],
	                 [-servo_HTot - support_width_sleeve - support_width_hinge, support_width_hinge + servo_axis_clear],
	                 [support_width_hinge, support_width_hinge + servo_axis_clear]
	                ]);

          // Round end
          for(i = [0:1]){
              translate([i*(-servo_HTot - support_width_sleeve - support_width_hinge), 0, 0]) rotate([0, 90, 0])
                cylinder(d = support_z_hinge, h = support_width_hinge, $fn = 32);
          }
        
        }
        union(){
            // Horn Big screw
            translate([-support_width_hinge/2, 0, 0]) rotate([0, 90, 0])
            #cylinder(d = bigscrew, h = 2*support_width_hinge, $fn =32);

            // Horn Small screw
            translate([-support_width_hinge/2, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                cylinder(d = smallscrew, h = 2*support_width_hinge, $fn =32);
        
            // Horn Small screw head
            translate([support_width_hinge - 1.7, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                #cylinder(d1 = smallscrew_head_d1, d2 = smallscrew_head_d2, h = 2*support_width_hinge, $fn =32);
        

            // Horn
            translate([-2, 0, 0]) rotate([90, 0, 90]) 
                horn_hk15328();
	
            // Bottom hinge hole
            translate([-servo_HTot - 2.5*support_width_hinge, 0, 0])
            rotate([0, 90, 0])
                #cylinder(d = mg946r_bottomhinge_hole, h = 2*support_width_hinge, $fn =32);
	  }
	
	}

}

module hinge_sleeve_alt_hinge_hk15328(screw){
    servo_axis_clear = (mg946r_horn_length - mg946r_horn_1stcircle/2 + 3);
    support_width_hinge = (mg946r_total_length - mg946r_length)/2 + 2;
    support_width_sleeve = (mg946r_total_length - mg946r_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = mg946r_length + 0.9;
    servo_H = mg946r_height + 0.5;
    support_z_sleeve = mg946r_width + 0.25;
    
    difference(){
    union(){
      translate([-17.1*abs(servo_axis_clear-servo_H), -servo_L - 2 * support_width_sleeve - hinge_sleeve_dist, 0]) rotate([0, 0, 90]) servo_hinge_hk15328();  
    }

    {
    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - (1.5) * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-13/16.5*servo_H, -servo_L - (1.5) * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
    }
  }
}




module hinge_sleeve_alt_sleeve_hk15328(screw){
    support_width_hinge = (hk15328_total_length - hk15328_length)/2 + 2;
    support_width_sleeve = (hk15328_total_length - hk15328_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = hk15328_length + 0.9;
    servo_H = hk15328_height + 0.5;
    support_z_sleeve = hk15328_width + 0.25;
    servo_axis_clear = (hk15328_horn_length -hk15328_horn_1stcircle/2 + 7);
    
  difference(){
    union(){
  
      translate([-15.5*abs(servo_axis_clear-servo_H), -servo_L, 0])
      rotate([0, 0, -90])
        if(screw == "one") servo_sleeve_hk15328(type = "bottom", hole = "one");
        else servo_sleeve_hk15328(type = "bottom_hole", hole = "two");
    }

    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-13/16.5*servo_H, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
  }
}


module sleeve_hinge_hk15328(screw){
    support_width_hinge = (hk15328_total_length - hk15328_length)/2 + 2;
    support_width_sleeve = (hk15328_total_length - hk15328_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = hk15328_length + 0.9;
    servo_H = hk15328_height + 0.5;
    support_z_sleeve = hk15328_width + 0.25;
    servo_axis_clear = (hk15328_horn_length -hk15328_horn_1stcircle/2 + 7);
    
    difference(){
      union(){
         translate([-sleeve_hinge_size/2+5 + support_width_sleeve, -sleeve_hinge_dist/2 - servo_H - support_width_sleeve, 0])
  cube([sleeve_hinge_size-12, sleeve_hinge_dist + 4, support_z_sleeve], center = true);

  translate([0, -servo_axis_clear - servo_H - 2 * support_width_hinge - sleeve_hinge_dist, 0]) 
    servo_hinge_hk15328();
    
  if(screw == "one") servo_sleeve_hk15328(type = "side_hole", hole = "one");
      else servo_sleeve_hk15328(type = "side_hole", hole = "two");
     }
       /*   
      // 1st screw
      
	    translate([-(sleeve_hinge_size - max(support_width_sleeve, support_width_hinge))/3, -servo_axis_clear - servo_H - 2 * support_width_hinge - 2*sleeve_hinge_dist, 0])
	    rotate([0, 90, 90]) 
	    #cylinder(d = 2.5, h = 100, $fn =32);
      // 2nd screw
	    translate([-(sleeve_hinge_size - max(support_width_sleeve, support_width_hinge))*2/3, -servo_axis_clear - servo_H - 2 * support_width_hinge - 2*sleeve_hinge_dist, 0])
	    rotate([0, 90, 90]) 
	    #cylinder(d = 2.5, h = 100, $fn =32);*/
  }
  
}





module servo_sleeve_tss10mg(type = "side_hole", hole = "two"){
    
    support_width_sleeve = (tss10mg_total_length - tss10mg_length)/2 + 2;
    servo_L = tss10mg_length + 0.9;
    servo_H = tss10mg_height;
    servo_fixation_hole_x = tss10mg_fixation_hole_x ;
    servo_fixation_hole_y = tss10mg_fixation_hole_y ;
    servo_fixation_hole_z = tss10mg_fixation_hole_z ;
    servo_hole_diameter = 2;
    support_z_sleeve = tss10mg_width + 0.25;
    servo_bottom_cylinder_diameter = tss10mg_bottom_cylinder_diameter;
    support_width_hinge = (tss10mg_total_length - tss10mg_length)/2 + 2;
    
    union(){
	  difference(){
	    linear_extrude(height = support_z_sleeve, center = true)
	    polygon( points=[[0,0],
	                 [support_width_sleeve, 0],
	                 [support_width_sleeve, -(servo_H + support_width_sleeve)],
	                 [-servo_L - support_width_sleeve, -(servo_H + support_width_sleeve)],
	                 [-servo_L - support_width_sleeve, 0],
	                 [-servo_L, 0],
	                 [-servo_L, -servo_H],
	                 [0, -servo_H]
	                ]);
	    // Servo fixation hole
	    translate([servo_fixation_hole_x, servo_fixation_hole_y, servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - servo_fixation_hole_x, servo_fixation_hole_y, servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
        if(hole == "two")
        {
            // Servo fixation hole
	    translate([servo_fixation_hole_x, servo_fixation_hole_y, -servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - servo_fixation_hole_x, servo_fixation_hole_y, -servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
        }
        
        // Servo cable carving (side start)
	    translate([-servo_L - 1.4, -servo_H - 1.4 + 1e-3, -4.2/2])
	    cube([support_width_sleeve, 7 + 1.4, 4.2]);
	
        if(type == "side_hole"){
  	      // Servo cable carving
	      translate([-servo_L, -1.4 - servo_H, -4.2/2])
	      cube([servo_L + support_width_sleeve, 1.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-10, -1.0 - servo_H, -3.2/2])
	      cube([servo_L + support_width_sleeve, 9, 3.2]);
        } else { // bottom_hole
  	      // Servo cable carving
	      translate([-servo_L, -1.4 - servo_H, -4.2/2])
	      cube([servo_L, 1.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-9, -1.5 * support_width_sleeve - servo_H, -3.2/2])
	      cube([9, 2 * support_width_sleeve, 3.2]);
        }
	  }
	
	  // Servo hinge
	  //translate([-servo_L + 4.5,  -(servo_H + support_width_sleeve), 0])
      translate([-servo_L + 6.5,  -(servo_H + support_width_sleeve), 0])
	  rotate([90, 0, 0])
	  cylinder(d = servo_bottom_cylinder_diameter, h = support_width_hinge-1, $fn =32);
	
	}

}


module servo_hinge_tss10mg(hinge_servo = "tss10mg"){
    support_width_sleeve = (tss10mg_total_length - tss10mg_length)/2 + 2;
    support_z_hinge = tss10mg_width + 0.25;
    support_width_hinge = (tss10mg_total_length - tss10mg_length)/2 + 2;
    servo_axis_clear = (tss10mg_horn_length -tss10mg_horn_1stcircle/2 + 7);
    servo_HTot = tss10mg_total_height ; //A
    bigscrew = tss10mg_horn_bigscrew;
    smallscrew = tss10mg_horn_smallscrew;
    smallscrew_length = tss10mg_horn_smallscrew_length;
    smallscrew_head_d1 = tss10mg_horn_head_d1;
    smallscrew_head_d2 = tss10mg_horn_head_d2;
	difference(){
        union(){
            
          linear_extrude(height = support_z_hinge, center = true)
            polygon( points=[
	                 [support_width_hinge, 0],
	                 [0, 0],
	                 [0, servo_axis_clear],
	                 [-servo_HTot - support_width_sleeve, servo_axis_clear],
	                 [-servo_HTot - support_width_sleeve, 0],
	                 [-servo_HTot - support_width_sleeve - support_width_hinge, 0],
	                 [-servo_HTot - support_width_sleeve - support_width_hinge, support_width_hinge + servo_axis_clear],
	                 [support_width_hinge, support_width_hinge + servo_axis_clear]
	                ]);

          // Round end
          for(i = [0:1]){
              translate([i*(-servo_HTot - support_width_sleeve - support_width_hinge), 0, 0]) rotate([0, 90, 0])
                cylinder(d = support_z_hinge, h = support_width_hinge, $fn = 32);
          }
        
        }
        union(){
            // Horn Big screw
            translate([-support_width_hinge/2, 0, 0]) rotate([0, 90, 0])
            #cylinder(d = bigscrew, h = 2*support_width_hinge, $fn =32);

            // Horn Small screw
            translate([-support_width_hinge/2, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                cylinder(d = smallscrew, h = 2*support_width_hinge, $fn =32);
        
            // Horn Small screw head
            translate([support_width_hinge - 1.7, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                #cylinder(d1 = smallscrew_head_d1, d2 = smallscrew_head_d2, h = 2*support_width_hinge, $fn =32);
        

            // Horn
            translate([-2, 0, 0]) rotate([90, 0, 90]) 
                horn_tss10mg_hinge();
	
            // Bottom hinge hole
            translate([-servo_HTot - 2.5*support_width_hinge, 0, 0])
            rotate([0, 90, 0])
                #cylinder(d = tss10mg_bottomhinge_hole, h = 2*support_width_hinge, $fn =32);
	  }
	
	}

}

module hinge_sleeve_alt_hinge_tss10mg(screw){
    servo_axis_clear = (hk15328_horn_length - hk15328_horn_1stcircle/2 + 3);
    support_width_hinge = (hk15328_total_length - hk15328_length)/2 + 2;
    support_width_sleeve = (hk15328_total_length - hk15328_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = hk15328_length + 0.9;
    servo_H = hk15328_height + 0.5;
    support_z_sleeve = hk15328_width + 0.25;
    
    difference(){
    union(){
      translate([-17.1*abs(servo_axis_clear-servo_H), -servo_L - 2 * support_width_sleeve - hinge_sleeve_dist, 0]) rotate([0, 0, 90]) servo_hinge_tss10mg();  
    }
    
    {
        
    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - (1.5) * support_width_sleeve - hinge_sleeve_dist-2, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-13/16.5*servo_H, -servo_L - (1.5) * support_width_sleeve - hinge_sleeve_dist-2, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
    }
  }
}




module hinge_sleeve_alt_sleeve_tss10mg(screw){
    support_width_hinge = (tss10mg_total_length - tss10mg_length)/2 + 2;
    support_width_sleeve = (tss10mg_total_length - tss10mg_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = tss10mg_length + 0.9;
    servo_H = tss10mg_height + 0.5;
    support_z_sleeve = tss10mg_width + 0.25;
    servo_axis_clear = (tss10mg_horn_length -tss10mg_horn_1stcircle/2 + 7);
    
  difference(){
    union(){
  
      translate([-15.5*abs(servo_axis_clear-servo_H), -servo_L, 0])
      rotate([0, 0, -90])
        if(screw == "one") servo_sleeve_tss10mg(type = "bottom", hole = "one");
        else servo_sleeve_tss10mg(type = "bottom_hole", hole = "two");
    }
    
    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - 1.5 * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-13/16.5*servo_H, -servo_L - 1.5 * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-13/16.5*servo_H, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
  }
}


module sleeve_hinge_tss10mg(screw){
    support_width_hinge = (tss10mg_total_length - tss10mg_length)/2 + 2;
    support_width_sleeve = (tss10mg_total_length - tss10mg_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = tss10mg_length + 0.9;
    servo_H = tss10mg_height + 0.5;
    support_z_sleeve = tss10mg_width + 0.25;
    servo_axis_clear = (tss10mg_horn_length -tss10mg_horn_1stcircle/2 + 7);
    
    difference(){
      union(){
         translate([-sleeve_hinge_size/2+5 + support_width_sleeve, -sleeve_hinge_dist/2 - servo_H - support_width_sleeve, 0])
  cube([sleeve_hinge_size-12, sleeve_hinge_dist + 4, support_z_sleeve], center = true);

  translate([0, -servo_axis_clear - servo_H - 2 * support_width_hinge - sleeve_hinge_dist, 0]) 
    servo_hinge_tss10mg();
    
  if(screw == "one") servo_sleeve_tss10mg(type = "side_hole", hole = "one");
      else servo_sleeve_tss10mg(type = "side_hole", hole = "two");
     }
       /*   
      // 1st screw
      
	    translate([-(sleeve_hinge_size - max(support_width_sleeve, support_width_hinge))/3, -servo_axis_clear - servo_H - 2 * support_width_hinge - 2*sleeve_hinge_dist, 0])
	    rotate([0, 90, 90]) 
	    #cylinder(d = 2.5, h = 100, $fn =32);
      // 2nd screw
	    translate([-(sleeve_hinge_size - max(support_width_sleeve, support_width_hinge))*2/3, -servo_axis_clear - servo_H - 2 * support_width_hinge - 2*sleeve_hinge_dist, 0])
	    rotate([0, 90, 90]) 
	    #cylinder(d = 2.5, h = 100, $fn =32);*/
  }
  
}

/*
module servo_sleeve_mg995(type = "side_hole", hole = "two"){
    
    support_width_sleeve = (mg995_total_length - mg995_length)/2 + 2;
    servo_L = mg995_length + 0.9;
    servo_H = mg995_height + 0.5;
    servo_fixation_hole_x = mg995_fixation_hole_x ;
    servo_fixation_hole_y = mg995_fixation_hole_y ;
    servo_fixation_hole_z = mg995_fixation_hole_z ;
    servo_hole_diameter = 2;
    support_z_sleeve = mg995_width + 0.25;
    servo_bottom_cylinder_diameter = mg995_bottom_cylinder_diameter;
    support_width_hinge = (mg995_total_length - mg995_length)/2 + 2;
    
    union(){
	  difference(){
	    linear_extrude(height = support_z_sleeve, center = true)
	    polygon( points=[[0,0],
	                 [support_width_sleeve, 0],
	                 [support_width_sleeve, -(servo_H + support_width_sleeve)],
	                 [-servo_L - support_width_sleeve, -(servo_H + support_width_sleeve)],
	                 [-servo_L - support_width_sleeve, 0],
	                 [-servo_L, 0],
	                 [-servo_L, -servo_H],
	                 [0, -servo_H]
	                ]);
	    // Servo fixation hole
	    translate([servo_fixation_hole_x, servo_fixation_hole_y, servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - servo_fixation_hole_x, servo_fixation_hole_y, servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
        if(hole == "two")
        {
            // Servo fixation hole
	    translate([servo_fixation_hole_x, servo_fixation_hole_y, -servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
	
	    // Servo fixation hole
	    translate([-servo_L - servo_fixation_hole_x, servo_fixation_hole_y, -servo_fixation_hole_z])
	    rotate([90, 0, 0])
	    cylinder(d = servo_hole_diameter, h = 15, $fn = 32);
        }
        
        // Servo cable carving (side start)
	    translate([-servo_L - 1.4, -servo_H - 1.4 + 1e-3, -4.2/2])
	    cube([support_width_sleeve, 7 + 1.4, 4.2]);
	
        if(type == "side_hole"){
  	      // Servo cable carving
	      translate([-servo_L, -1.4 - servo_H, -4.2/2])
	      cube([servo_L + support_width_sleeve, 1.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-10, -1.0 - servo_H, -3.2/2])
	      cube([servo_L + support_width_sleeve, 9, 3.2]);
        } else { // bottom_hole
  	      // Servo cable carving
	      translate([-servo_L, -1.4 - servo_H, -4.2/2])
	      cube([servo_L, 1.5, 4.1]);
	
	      // Servo cable header hole
	      translate([-9, -1.5 * support_width_sleeve - servo_H, -3.2/2])
	      cube([9, 2 * support_width_sleeve, 3.2]);
        }
	  }
	
	  // Servo hinge
	  //translate([-servo_L + 4.5,  -(servo_H + support_width_sleeve), 0])
      translate([-servo_L + 8,  -(servo_H + support_width_sleeve), 0])
	  rotate([90, 0, 0])
	  cylinder(d = servo_bottom_cylinder_diameter, h = support_width_hinge-1, $fn =32);
	
	}

}


module servo_hinge_mg995(hinge_servo = "mg995"){
    support_width_sleeve = (mg995_total_length - mg995_length)/2 + 2;
    support_z_hinge = mg995_width + 0.25;
    support_width_hinge = (mg995_total_length - mg995_length)/2 + 2;
    servo_axis_clear = (mg995_horn_length -mg995_horn_1stcircle/2 + 3);
    servo_HTot = mg995_total_height + 0.5; //A
    bigscrew = mg995_horn_bigscrew;
    smallscrew = mg995_horn_smallscrew;
    smallscrew_length = mg995_horn_smallscrew_length;
    smallscrew_head_d1 = mg995_horn_head_d1;
    smallscrew_head_d2 = mg995_horn_head_d2;
	difference(){
        union(){
            
          linear_extrude(height = support_z_hinge, center = true)
            polygon( points=[
	                 [support_width_hinge, 0],
	                 [0, 0],
	                 [0, servo_axis_clear],
	                 [-servo_HTot - support_width_sleeve, servo_axis_clear],
	                 [-servo_HTot - support_width_sleeve, 0],
	                 [-servo_HTot - support_width_sleeve - support_width_hinge, 0],
	                 [-servo_HTot - support_width_sleeve - support_width_hinge, support_width_hinge + servo_axis_clear],
	                 [support_width_hinge, support_width_hinge + servo_axis_clear]
	                ]);

          // Round end
          for(i = [0:1]){
              translate([i*(-servo_HTot - support_width_sleeve - support_width_hinge), 0, 0]) rotate([0, 90, 0])
                cylinder(d = support_z_hinge, h = support_width_hinge, $fn = 32);
          }
        
        }
        union(){
            // Horn Big screw
            translate([-support_width_hinge/2, 0, 0]) rotate([0, 90, 0])
            #cylinder(d = bigscrew, h = 2*support_width_hinge, $fn =32);

            // Horn Small screw
            translate([-support_width_hinge/2, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                cylinder(d = smallscrew, h = 2*support_width_hinge, $fn =32);
        
            // Horn Small screw head
            translate([support_width_hinge - 1.7, smallscrew_length, 0])
            rotate([0, 90, 0]) 
                #cylinder(d1 = smallscrew_head_d1, d2 = smallscrew_head_d2, h = 2*support_width_hinge, $fn =32);
        

            // Horn
            translate([-2, 0, 0]) rotate([90, 0, 90]) 
                horn_mg995();
	
            // Bottom hinge hole
            translate([-servo_HTot - 2.5*support_width_hinge, 0, 0])
            rotate([0, 90, 0])
                #cylinder(d = mg946r_bottomhinge_hole, h = 2*support_width_hinge, $fn =32);
	  }
	
	}

}

module hinge_sleeve_alt_hinge_mg995(screw){
    support_width_hinge = (mg995_total_length - mg995_length)/2 + 2;
    support_width_sleeve = (mg995_total_length - mg995_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = mg995_length + 0.9;
    servo_H = mg995_height + 0.5;
    support_z_sleeve = mg995_width + 0.25;
    servo_axis_clear = (mg995_horn_length -mg995_horn_1stcircle/2 + 3);
    
    difference(){
    union(){
      translate([-17.1*abs(servo_axis_clear-servo_H), -servo_L - 2 * support_width_sleeve - hinge_sleeve_dist, 0]) rotate([0, 0, 90]) servo_hinge_mg995();  
    }

    for (i = [0:1]){
    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - (i+0.5) * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-13/16.5*servo_H, -servo_L - (i+0.5) * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
    }
  }
}


module hinge_sleeve_alt_sleeve_mg995(screw){
    servo_axis_clear = (mg946r_horn_length - mg946r_horn_1stcircle/2 + 3);
    support_width_hinge = (mg946r_total_length - mg946r_length)/2 + 2;
    support_width_sleeve = (mg946r_total_length - mg946r_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = mg946r_length + 0.9;
    servo_H = mg946r_height + 0.5;
    support_z_sleeve = mg946r_width + 0.25;
    servo_axis_clear = (mg946r_horn_length - mg946r_horn_1stcircle/2 + 3);
    
  difference(){
    union(){
  
      translate([-15.5*abs(servo_axis_clear-servo_H), -servo_L, 0])
      rotate([0, 0, -90])
        if(screw == "one") servo_sleeve_mg995(type = "bottom", hole = "one");
        else servo_sleevemg995(type = "bottom_hole", hole = "two");
    }
    
    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - 1.5 * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-13/16.5*servo_H, -servo_L - 1.5 * support_width_sleeve - hinge_sleeve_dist, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-5/16.5*servo_H, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);

    translate([-17.1*abs(servo_axis_clear-servo_H)-13/16.5*servo_H, -servo_L - 0.5 * support_width_sleeve, 0])
    #cylinder(d = 2.5, h = 30, center = true, $fn =32);
  }
}


module sleeve_hinge_mg995(screw){
    support_width_hinge = (mg995_total_length - mg995_length)/2 + 2;
    support_width_sleeve = (mg995_total_length - mg995_length)/2 + 3;
    sleeve_hinge_dist = (support_width_hinge+support_width_sleeve);
    sleeve_hinge_size = sleeve_hinge_dist*2;  
    servo_L = mg995_length + 0.9;
    servo_H = mg995_height + 0.5;
    support_z_sleeve = mg995_width + 0.25;
    servo_axis_clear = (mg995_horn_length -mg995_horn_1stcircle/2 + 3);
    
    difference(){
      union(){
         translate([-sleeve_hinge_size/2+2 + support_width_sleeve, -sleeve_hinge_dist/2 - servo_H - support_width_sleeve, 0])
  cube([sleeve_hinge_size-6, sleeve_hinge_dist + 2, support_z_sleeve], center = true);

  translate([0, -servo_axis_clear - servo_H - 2 * support_width_hinge - sleeve_hinge_dist, 0]) 
    servo_hinge_mg995();
    
  if(screw == "one") servo_sleeve_mg995(type = "side_hole", hole = "one");
      else servo_sleeve_mg995(type = "side_hole", hole = "two");
     }
       /*   
      // 1st screw
      
	    translate([-(sleeve_hinge_size - max(support_width_sleeve, support_width_hinge))/3, -servo_axis_clear - servo_H - 2 * support_width_hinge - 2*sleeve_hinge_dist, 0])
	    rotate([0, 90, 90]) 
	    #cylinder(d = 2.5, h = 100, $fn =32);
      // 2nd screw
	    translate([-(sleeve_hinge_size - max(support_width_sleeve, support_width_hinge))*2/3, -servo_axis_clear - servo_H - 2 * support_width_hinge - 2*sleeve_hinge_dist, 0])
	    rotate([0, 90, 90]) 
	    #cylinder(d = 2.5, h = 100, $fn =32);*/
 /* }
  
}
*/
module s8330m_final(){
    motor_s8330m();
    translate([0,-30,13]) rotate([90,0,-90]) 
        color("white") sleeve_hinge_s8330m("two");
    translate([0,17,31]) rotate([0,-90,180*$t-90]) 
        color("white")servo_hinge_s8330m();
    translate([0,1,- 118.4]) rotate([90,0,0]) 
        motor_s8330m();
    translate([0,-65,-88.4]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_sleeve_s8330m();
}

module mg946r_final(){
    motor_mg946r();
    rotate([0,0,180*$t-90]) translate([-1,-47-19+17.5,109.5-199.5+199.5]) rotate([90,0,-90])
         color("white") hinge_sleeve_alt_hinge_mg946r();
    translate([0,-38.25+17.5,9-199.5+199.5]) rotate([90,0,-90])
         color("white") sleeve_hinge_mg946r("two");
    translate([0,-75.5,-80.05]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_sleeve_mg946r();
    translate([0,3,-100.5]) rotate([90,0,0])
        motor_mg946r();
}

module hk15328_final(){
    motor_hk15328();
    translate([0,-64-2.45,90.5]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_hinge_hk15328();
    translate([0,-21,8]) rotate([90,0,-90])
         color("white") sleeve_hinge_hk15328("two");
    translate([0,-66.5,-70.5]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_sleeve_hk15328();
    translate([0,3.5,-91.5]) rotate([90,0,0])
        motor_hk15328();
}

module tss10mg_final(){
    motor_tss10mg();
    translate([0,-131.5,84]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_hinge_tss10mg();
    translate([0,-12,5]) rotate([90,0,-90])
         color("white") sleeve_hinge_tss10mg("two");
    translate([0,-77.5,-55.5]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_sleeve_tss10mg();
    translate([0,5.25,-67.5]) rotate([90,0,0])
        motor_tss10mg();
}


/*
module mg995_final(){
    motor_mg995();
    translate([0,0,0]) rotate([90,0-90])
        color("white") hinge_sleeve_alt_hinge_mg995();
    translate([0,0,0]) rotate([90,0,-90])
         color("white") sleeve_hinge_mg995("two");
    translate([0,0,0]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_sleeve_mg995();
    translate([0,0,0]) rotate([90,0,0])
        motor_mg995();
}


module tgy1501_final(){
    motor_tgy1501();
    translate([0,0,0]) rotate([90,0-90])
        color("white") hinge_sleeve_alt_hinge_tgy1501();
    translate([0,0,0]) rotate([90,0,-90])
         color("white") sleeve_hinge_tgy1501("two");
    translate([0,0,0]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_sleeve_tgy1501();
    translate([0,0,0]) rotate([90,0,0])
        motor_tgy1501();
}

module xgd11hmb_final(){
    motor_xgd11hmb();
    translate([0,0,0]) rotate([90,0-90])
        color("white") hinge_sleeve_alt_hinge_xgd11hmb();
    translate([0,0,0]) rotate([90,0,-90])
         color("white") sleeve_hinge_xgd11hmb("two");
    translate([0,0,0]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_sleeve_xgd11hmb();
    translate([0,0,0]) rotate([90,0,0])
        motor_xgd11hmb();
}


module hd1160a_final(){
    motor_hd1160a();
    translate([0,0,0]) rotate([90,0-90])
        color("white") hinge_sleeve_alt_hinge_hd1160a();
    translate([0,0,0]) rotate([90,0,-90])
         color("white") sleeve_hinge_hd1160a("two");
    translate([0,0,0]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_sleeve_hd1160a();
    translate([0,0,0]) rotate([90,0,0])
        motor_hd1160a();
}

module bb928_final(){
    motor_bb928();
    translate([0,0,0]) rotate([90,0-90])
        color("white") hinge_sleeve_alt_hinge_bb928();
    translate([0,0,0]) rotate([90,0,-90])
         color("white") sleeve_hinge_bb928("two");
    translate([0,0,0]) rotate([90,0,-90])
        color("white") hinge_sleeve_alt_sleeve_bb928();
    translate([0,0,0]) rotate([90,0,0])
        motor_bb928();
}*/

module servo_render(){
    s8330m_final(); //HT
    translate([0,-17.5,-199.5]) rotate([0,0,0])
        mg946r_final(); //MT1
    translate([0,-26.5,-375.3]) rotate([0,0,0])
        hk15328_final(); //MT2
    translate([0,-30,-528.75]) rotate([0,0,0])
        tss10mg_final(); //LT1
    //hd1160a_final(); //LT2
    //bb928_final(); //LT3
    
// ---------- special package ------------ //
    //mg995_final();
    //xgd11hmb_final();
    //tgy1501_final();
}





servo_render();

