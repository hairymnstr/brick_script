// stud space
ss = 7.95;
// plate height
ph = 3.25;
// stud radius
sr = 2.425;
// stud height
sh = 1.7;
// wall thickness
wt = 1.533;
// top thickness
tt = 1.1;
// bottom stud outer radius
bso = 3.25;
// bottom stud inner radius
bsi = 2.5;
// text on the stud
stud_text = "BRICK";
stud_text_size = 1;

module brick(x=1,y=1,z=1) {
    union() {
        difference() {
            cube([x*ss,y*ss,z*ph]);
            translate([wt,wt,-tt]) cube([x*ss-2*wt,y*ss-2*wt,z*ph]);
        }
        for(ix=[0:x-1]) {
            for(iy=[0:y-1]) {
                translate([ix*ss + ss/2,iy*ss + ss/2,ph*z]) {
                    union() {
                        cylinder(r1=sr,r2=sr,h=sh,$fn=32);
                        translate([0,0,sh]) linear_extrude(height=0.2) {
                            scale([1, 1.3, 1]) text(text=stud_text, size=stud_text_size, valign="center", halign="center", font="DejaVu Sans:style=Oblique");
                        }
                    }
                }
            }
        }
        if(x > 1 && y > 1) {
            for(ix=[1:x-1]) {
                for(iy=[1:y-1]) {
                    translate([ix*ss,iy*ss,0]) {
                        union() {
                            difference() {
                                cylinder(r1=bso,r2=bso,h=z*ph-tt,$fn=32);
                                translate([0,0,-.25]) cylinder(r1=bsi,r2=bsi,h=z*ph+.5,$fn=32);
                            }
                            rotate([0,0,0]) translate([2.425,-1.5,0]) cube([0.25,3,z*ph-tt]);
                            rotate([0,0,90]) translate([2.425,-1.5,0]) cube([0.25,3,z*ph-tt]);
                            rotate([0,0,180]) translate([2.425,-1.5,0]) cube([0.25,3,z*ph-tt]);
                            rotate([0,0,270]) translate([2.425,-1.5,0]) cube([0.25,3,z*ph-tt]);
                        }
                    }
                }
            }
        } else if(x > 1) {
            for(ix=[1:x-1]) {
                translate([ix*ss,ss/2,0]) {
                    cylinder(r1=wt,r2=wt,h=ph*z-tt,$fn=32);
                }
            }
        } else if(y > 1) {
            for(iy=[1:y-1]) {
                translate([ss/2,iy*ss,0]) {
                    cylinder(r1=wt,r2=wt,h=ph*z-tt,$fn=32);
                }
            }
        }
    }
}

module slope(x=1, y=1, z=1) {
    difference() {
        union() {
            brick(x, y, z);
            dx = ss-wt;
            dy = 3*ph-2.1-tt;
            r = sqrt(dx * dx + dy * dy);
            phi = atan2(dy, dx);
            translate([wt, 0, 2.1]) rotate([0, -phi, 0]) cube([r, y * ss, ss]);
        }
        dx = ss;
        dy = 3*ph-2.2;
        r = sqrt(dx * dx + dy * dy);
        phi = atan2(dy, dx);
        translate([0, -1, 2.2]) rotate([0, -phi, 0]) cube([r+1, y*ss+2, ss]);
    }
}

module inverted_slope(x=1, y=1, z=1) {
    difference() {
        union() {
            brick(1, y, z);
            intersection() {
                translate([ss, 0, 0]) cube([(x-1)*ss, y*ss, ph*z]);
                dx = (x-1)*ss;
                dy = z*ph-1.5;
                r = sqrt(dx * dx + dy * dy);
                phi = atan2(-dy, dx);
                translate([ss, -1, 0]) rotate([0, phi, 0]) cube([r+2, y*ss+2, 2*ss]);
            }
            for(ix=[1:x-1]) {
                for(iy=[0:y-1]) {
                    translate([ix*ss + ss/2,iy*ss + ss/2,ph*z]) {
                        union() {
                            cylinder(r1=sr,r2=sr,h=sh,$fn=32);
                            translate([0,0,sh]) linear_extrude(height=0.2) {
                                scale([1, 1.3, 1]) text(text=stud_text, size=stud_text_size, valign="center", halign="center", font="DejaVu Sans:style=Oblique");
                            }
                        }
                    }
                }
            }
        }
        for(ix=[1:x-1]) {
            for(iy=[0:y-1]) {
                translate([ix*ss + ss/2,iy*ss + ss/2,0]) {
                    cylinder(r1=sr+0.2,r2=sr+0.2,h=sh+0.2,$fn=32);
                }
            }
        }
    }
}

module cheese_wedge(n=1) {
    union() {
        difference() {
            difference() {
                cube([ss, ss*n, ph*2]);
                translate([wt, wt, -1]) cube([ss-2*wt, ss*n-2*wt, sh+1.5]);
                translate([-0.5,-1,-0.5]) cube([1, ss*n+2, 1]);
                translate([ss-0.5, -1, -0.5]) cube([1, ss*n+2, 1]);
                translate([-1, -0.5, -0.5]) cube([ss+2, 1, 1]);
                translate([-1, ss*n-0.5, -0.5]) cube([ss+2, 1, 1]);
            }
            dy = ph*2 - 2.2;
            dx = ss;
            phi = atan2(dy, dx);
            translate([0, -1, 2.2]) rotate([0,-phi, 0]) cube([ss*2, ss*n+2, ph*3]);
        }
        if(n > 1) {
            for(iy=[1:n-1]) {
                translate([ss/2,iy*ss,0]) {
                    cylinder(r1=wt,r2=wt,h=sh+1,$fn=32);
                }
            }
        }
    }
}

module side_stud() {
    difference() {
        union() {
            difference() {
                union() {
                    brick(1, 1, 3);
                    translate([0, 6.4-wt, 1.4]) cube([ss, wt, ph*3 - 1.4]);
                }
                translate([-1, 6.4, 1.6]) cube([ss+2, ss+2, ph * 3]);
                translate([wt, -1, ph*3-ss+wt]) cube([ss-2*wt, ss-2*wt, ss-2*wt]);
                translate([ss/2, ss/2, 2.1/2]) cylinder(h=2.1, d=ss - 2*wt, center=true, $fn=64);
            }
            translate([ss/2, ss, ph*3 - ss/2]) rotate([90, 0, 0]) cylinder(r=sr,h=sh, $fn=32);
        }
        translate([ss/2, ss+1, ph*3-ss/2]) rotate([90, 0, 0]) cylinder(d=3.3, h=sh+4, $fn=32);
    }
}

module round_tile_1() {
    union() {
        difference() {
            minkowski() {
                sphere(0.25, $fn=64);
                cylinder(d=ss-0.5, h=ph-0.25, $fn=64);
            }
            translate([0, 0, -1]) cylinder(d=ss-wt*2+0.5, ph-tt+1, $fn=64);
            translate([0, 0, -2]) cylinder(d=ss, h=2);
            difference() {
                translate([0, 0, -0.5]) cylinder(d=ss+1,h=1, $fn=64);
                translate([0, 0, -1]) cylinder(d=ss-1,h=2, $fn=64);
            }
        }
        translate([-ss/4, ss/2-wt, 0]) cube([ss/2, wt/4.5, ph-(tt/2)]);
        translate([-ss/4, -(ss/2-wt)-wt/4.5, 0]) cube([ss/2, wt/4.5, ph-(tt/2)]);
        translate([ss/2-wt, -ss/4, 0]) cube([wt/4.5, ss/2, ph-(tt/2)]);
        translate([-(ss/2-wt)-wt/4.5, -ss/4, 0]) cube([wt/4.5, ss/2, ph-(tt/2)]);
    }
}

module eye_outer() {
    difference() {
        round_tile_1();
        difference() {
            translate([1, 0, ph-0.25]) cylinder(h=0.5, d=4.6, $fn=64);
            translate([2, 0, ph-0.5]) cylinder(h=1, d=2, $fn=64);
        }
    }
}

module eye_inner() {
    difference() {
        translate([1, 0, 0]) cylinder(h=0.25,d=4.5, $fn=64);
        translate([2, 0, -0.5]) cylinder(h=1, d=2.1, $fn=64);
    }
}

module round_plate_1() {
    difference() {
        union() {
            difference() {
                union() {
                    cylinder(h=ph,d=ss, $fn=64);
                    translate([0,0,ph])
                    union() {
                        cylinder(r1=sr,r2=sr,h=sh,$fn=32);
                        translate([0,0,sh]) linear_extrude(height=0.2) {
                            scale([1, 1.3, 1]) text(text=stud_text, size=stud_text_size, valign="center", halign="center", font="DejaVu Sans:style=Oblique");
                        }
                    }
                }
                translate([0,0,-0.5]) cylinder(h=ph-tt+0.5,d=ss-wt*2+0.5, $fn=64);
            }
            translate([-ss/4, ss/2-wt, 0]) cube([ss/2, wt/4.5, ph-(tt/2)]);
            translate([-ss/4, -(ss/2-wt)-wt/4.5, 0]) cube([ss/2, wt/4.5, ph-(tt/2)]);
            translate([ss/2-wt, -ss/4, 0]) cube([wt/4.5, ss/2, ph-(tt/2)]);
            translate([-(ss/2-wt)-wt/4.5, -ss/4, 0]) cube([wt/4.5, ss/2, ph-(tt/2)]);            
        }
        difference() {
            translate([0,0,-0.5]) cylinder(h=ph-0.5,d=ss+1, $fn=64);
            translate([0, 0, -1]) cylinder(h=ph+1,d=6.5, $fn=64);
        }
    }
}

module round_plate_1_hole() {
    union() {
        difference() {
            union() {
                difference() {
                    union() {
                        cylinder(h=ph,d=ss, $fn=64);
                        translate([0,0,ph])
                        cylinder(r1=sr,r2=sr,h=sh,$fn=32);
                    }
                    translate([0,0,-0.5]) cylinder(h=ph-tt+0.5,d=ss-wt*2+0.5, $fn=64);
                }
                translate([-ss/4, ss/2-wt, 0]) cube([ss/2, wt/4.5, ph-(tt/2)]);
                translate([-ss/4, -(ss/2-wt)-wt/4.5, 0]) cube([ss/2, wt/4.5, ph-(tt/2)]);
                translate([ss/2-wt, -ss/4, 0]) cube([wt/4.5, ss/2, ph-(tt/2)]);
                translate([-(ss/2-wt)-wt/4.5, -ss/4, 0]) cube([wt/4.5, ss/2, ph-(tt/2)]);            
            }
            cylinder(h=2*ph, d=3.3, $fn=64);
            difference() {
                translate([0,0,-0.5]) cylinder(h=ph-0.5,d=ss+1, $fn=64);
                translate([0, 0, -1]) cylinder(h=ph+1,d=6.5, $fn=64);
            }
        }
        hi=3.05;
        pad = 0.2;
        pw = 3;
        translate([0, hi/2+pad/2, ph-tt+(sh+tt)/2]) cube([pw, pad, sh+tt],center=true);
        translate([0, -(hi/2+pad/2), ph-tt+(sh+tt)/2]) cube([pw, pad, sh+tt],center=true);
        translate([hi/2+pad/2, 0, ph-tt+(sh+tt)/2]) cube([pad, pw, sh+tt],center=true);
        translate([-(hi/2+pad/2), 0, ph-tt+(sh+tt)/2]) cube([pad, pw, sh+tt],center=true);
    }
}

module arch_3by1() {
    difference() {
        union() {
            brick(3, 1, 3);
            brick(1, 1, 3);
            translate([ss*2, 0, 0]) brick(1, 1, 3);
        }
        translate([ss*1.5, -1, 3*ph-3-ss/2]) rotate([-90, 0, 0]) cylinder(h=ss+2,d=ss, $fn=64);
        translate([ss, -1, -1]) cube([ss, ss+2, 3*ph-3-ss/2+1]);
        translate([ss, wt, -1]) cube([ss, ss-wt*2, 3*ph-tt+1]);
    }
}

module demo() {
    brick();

    translate([0,10,0]) brick(5,2,1);

    translate([0,-30,0]) brick(3,3,3);

    translate([0,30,0]) brick(5,1,1);

    translate([-10,0,0]) brick(1,5,1);
    
    translate([-10,-30,0]) cheese_wedge(2);
    
    translate([-30,10,0]) slope(2, 3, 3);
    
    translate([-10,-10,0]) rotate([0, 0, 90]) side_stud();
}

//brick(3,1,1);
//round_plate_1_hole();
//arch_3by1();
//slope(2,1,3);
//inverted_slope(3,1,3);
//round_tile_1();
//eye_outer();
//eye_inner();
//cheese_wedge(1);
//side_stud();
demo();