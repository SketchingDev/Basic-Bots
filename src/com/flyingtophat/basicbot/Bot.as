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

package com.flyingtophat.basicbot
{
    import com.flyingtophat.geometry.Circle;
    import com.flyingtophat.physics.Velocity;
    import flash.display.Graphics;
    import flash.display.Sprite;
	
	/**
	 * The Bot class represents a bot with rudimentary functionality for changing
     * velocity, drawing itself, moving forward and detecting other bots within
     * its proximity.
     *
     * This class is designed to be sub-classed allowing for ...
	 *
	 * Each bot has a proximity around which can be used to detect the presence
	 * of any other bots within a certain radius of the bot.
	 *
	 * This class is designed to be sub-classed in order to build in more
	 * complex characteristics.
	 *
	 * @internal Class mutators that result in complex tasks, such as redrawing
	 * a Sprite, are methods prefixed with "set".
	 * @author <a href="http://flyingtophat.co.uk">Lucas</a>
	 */
	public class Bot implements IBot
	{
		protected static const DEFAULT_BORDER_WIDTH:uint = 2;
		protected static const DEFAULT_BORDER_COLOUR:uint = 0x000000;
		
		private var _botSprite:Sprite;
		private var _velocity:Velocity;
		private var _colour:uint;
		
		/**
		 * Visibility of the bot's communication proximity
		 * @default false
		 */
		private var _zoneVisible:Boolean = false;
		
		/* Used for basic collision detection */
		private var _botCircle:Circle;

        /**
         * The zone around the bot within which it can communicate with other
         * bots */
		private var _commZone:Circle;
		
		public function Bot(colour:uint = 0xFFFFFF, radius:uint = 5, proximityRadius:uint = 5)
		{
			_velocity = new Velocity(0, 0);
			_colour = colour;
			_botCircle = new Circle(0, 0, radius);
			_commZone = new Circle(0, 0, proximityRadius);
		}
		
		/**
		 * Handles the drawing of the bot and its proximity.
		 * It is only called if the bot's sprite has been called through getSprite()
		 * @param	g	Bot sprite's graphic
		 */
		protected function redrawSelf(g:Graphics):void
		{
			g.clear();
			
			if (_zoneVisible) drawCommunicationZone(g);
			drawBot(g);
		}

		private function drawCommunicationZone(g:Graphics):void
		{
			g.beginFill(0xC4FB89, 0.5);
			g.drawCircle(0, 0, _commZone.radius);
			g.endFill();
		}
		
		protected function drawBot(g:Graphics):void
		{
			g.lineStyle(DEFAULT_BORDER_WIDTH, DEFAULT_BORDER_COLOUR);
			g.beginFill(_colour);
			g.drawCircle(0, 0, _botCircle.radius);
			g.endFill();
		}
		
        /**
         * @inheritDoc
         * @param	bot
         */
		public function communicate(bot:IBot):void
		{
			// Designed to be overridden by sub-classes.
		}
		
        /**
         * @inheritDoc
         * It is best to move the bot within this stage by
		 * using super.moveForward().
         */
		public function wake():void
		{
			// Designed to be overridden by sub-classes.
		}
		
        /**
         * @inheritDoc
         */
		public function die():void
		{
			// Designed to be overridden by sub-classes.
		}
		
		/**
		 * Moves the bot according to its velocity
		 */
		protected function moveForward():void
		{
			this.x += Math.cos(_velocity.direction) * _velocity.speed;
			this.y += Math.sin(_velocity.direction) * _velocity.speed;
		}
		
        /**
		 * Gets the sprite that represents the bot.
         * Sub-classes overriding this method must call the super class.
         *
		 * @internal See class description on why this isn't an inbuilt accessor
		 * @return	Sprite representing the bot and its proximity
         */
		public function getSprite():Sprite
		{
			if (_botSprite == null)
			{
				_botSprite = new Sprite();
				redrawSelf(_botSprite.graphics);
				
				_botSprite.x = this.x;
				_botSprite.y = this.y;
			}
			
			return _botSprite;
		}
		
        /**
		 * Allows the caller to determine if the bot has created a Sprite
		 * for itself through the calling of the getSprite method.
		 *
		 * Useful if you want to determine if the Sprite has been added to a
		 * display container without encuring the processing costs of
		 * calling the getSprite() method.
         */
		public function get hasSprite():Boolean
		{
			return (_botSprite != null);
		}
		
        /**
         * @inheritDoc
         * Testing for a collision between this bot's
         * "communication proximity" and the other bot's body
         */
		public function hitTest(bot:IBot):Boolean
		{
			return _commZone.intersects(bot.body);
		}
		
		public function get velocity():Velocity
        {
            return _velocity;
        }

		public function set velocity(v:Velocity):void
        {
            _velocity = v;
        }
		
		/**
		 * Colour of the bot
		 */
		protected function get colour():uint
        {
            return _colour;
        }
		
		/**
		 * Set the colour of the bot
		 * @internal See class description on why this isn't a inbuilt mutator
		 */
		protected function setColour(colour:uint):void
		{
			if (colour != _colour)
			{
				_colour = colour;
				
				if (_botSprite != null)
					redrawSelf(_botSprite.graphics);
			}
		}
		
        /**
         * @inheritDoc
         */
		public function get body():Circle
        {
            return _botCircle;
        }
		
		/**
		 * Sets the pixel radius of the bot
		 * @internal See class description on why this isn't an inbuilt mutator
		 */
		protected function setRadius(radius:Number):void
		{
			if (radius != _botCircle.radius)
			{
				_botCircle.radius = radius;
				
				if (_botSprite != null)
					redrawSelf(_botSprite.graphics);
			}
		}
		
		public function get radius():Number
        {
            return _botCircle.radius;
        }
		
		/**
		 * Set the pixel radius of the bot's proximity.
		 * Changing this will cause the bot to be redrawn
		 * @internal See class description on why this isn't an inbuilt mutator
		 */
		protected function setProximityRadius(radius:Number):void
		{
			if (radius != _commZone.radius)
			{
				_commZone.radius = radius;
				
				if (_botSprite != null)
					redrawSelf(_botSprite.graphics);
			}
		}
		
        /**
         * The radius of the bot's "awareness proximity"
         */
		protected function get proximityRadius():Number
        {
            return _commZone.radius;
        }
		
		public function get x():Number
        {
            return _botCircle.x;
        }

		public function set x(position:Number):void
		{
			_botCircle.x = position;
			_commZone.x = position;
			
			if (_botSprite != null) _botSprite.x = position;
		}
		
		public function get y():Number
        {
            return _botCircle.y;
        }

		public function set y(position:Number):void
		{
			_botCircle.y = position;
			_commZone.y = position;
			
			if (_botSprite != null) _botSprite.y = position;
		}
		
	}

}