/*
 * Copyright (c) 2011 Lucas http://www.flyingtophat.co.uk
 *
 * This software is provided 'as-is', without any express or implied
 * warranty.  In no event will the authors be held liable for any damages
 * arising from the use of this software.
 * Permission is granted to anyone to use this software for any purpose,
 * including commercial applications, and to alter it and redistribute it
 * freely, subject to the following restrictions:
 * 1. The origin of this software must not be misrepresented; you must not
 * claim that you wrote the original software. If you use this software
 * in a product, an acknowledgment in the product documentation would be
 * appreciated but is not required.
 * 2. Altered source versions must be plainly marked as such, and must not be
 * misrepresented as being the original software.
 * 3. This notice may not be removed or altered from any source distribution.
 */

package com.flyingtophat.geometry
{
    
    /**
     * @author <a href="http://flyingtophat.co.uk">Lucas</a>
     */
    public class Circle
    {
        public var x:Number;
        public var y:Number;
        public var radius:Number;
        
        public function Circle(x:Number = 0, y:Number = 0, radius:Number = 0)
        {
            this.x = x;
            this.y = y;
            this.radius = radius;
        }
        
        /**
         * Tests for an intersection with another circle.
         * @param    circle    Circle to test against for an intersection
         * @return    Returns true upon detecting an intersection,
         *  else false
         */
        public function intersects(circle:Circle):Boolean
        {
            return (this.radius + circle.radius) * (this.radius + circle.radius)
                    > ((this.x - circle.x) * (this.x - circle.x) +
                      (this.y - circle.y) * (this.y - circle.y));
        }
        
    }

}