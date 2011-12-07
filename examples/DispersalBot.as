package
{
    import com.flyingtophat.basicbot.Bot;
    import com.flyingtophat.basicbot.IBot;
    import flash.display.Graphics;
    import flash.display.Sprite;
    import flash.geom.Rectangle;
    
    /**
     * A cell that displays a simple "avoidance" behaviour.
     * If another cell moves into its proximity then it
     * moves away in the opposite direction.
     *
     * @author <a href="http://flyingtophat.co.uk">Lucas</a>
     */
    public class DispersalBot extends Bot
    {
        private static const BOT_RADIUS:uint = 5;
        private static const MOVEMENT_INDICATOR_COLOUR:uint = 0xFF0000;
        
        private const _movedIndicator:Sprite = new Sprite();
        private var _movementAngle:Number = 0;
        private var _randomCounter:uint = 0;

        /**
         * Angle used to deviate the bot's direction everytime it moves.
         * Without this if two bots were ontop of eachother then they
         * would constantly move together
         */
        private const _angleDeviation:Number = Math.random() / 10;
        
        public function DispersalBot(colour:uint = 0xFFFFFF)
        {
            super(colour,
                BOT_RADIUS, // Defind bot's radius
                (BOT_RADIUS * 3) // Set the distance over which it can
            );                   // communicate with other bots
        }
        
        /** Override to redraw motion indicator */
        override protected function redrawSelf(g:Graphics):void
        {
            super.redrawSelf(g);
            
            drawMoveIndicator(
                    _movedIndicator.graphics,
                    (super.radius / 2),
                    MOVEMENT_INDICATOR_COLOUR);
        }
        
        /**
         * Draws in centre of graphic
         * @param    g
         * @param    size
         * @param    colour
         */
        protected function drawMoveIndicator(g:Graphics, radius:uint, colour:uint):void
        {
            g.clear();
            g.beginFill(colour);
            g.drawCircle(0, 0, radius);
            g.endFill();
        }
        
        /**
         * Updates the bots direction so that it will move in the opposite
         * direction to any bot that enters it's proximity.
         * The direction also randomly deviates every 50 times
         * this method is called.
         */
        override public function communicate(bot:IBot):void
        {
            if (bot == null) throw new ArgumentError("Parameter must be an object");
            
            if (velocity.speed == 0)
            {
                velocity.speed = 1;
                
                // Get angle of this cell to the other
                velocity.direction = Math.atan2(
                        (bot.y - this.y),
                        (bot.x - this.x)
                    );
                
                velocity.invertDirection();
                velocity.direction += _angleDeviation;
            }
        }
        
        /**
         * Moves the bot in the direction determined by its
         * interaction with other bots.
         *
         * An indicator is shown every time it moves.
         */
        override public function wake():void
        {
            _movedIndicator.visible = (velocity.speed > 0);
            
            if (velocity.speed > 0)
            {
                this.moveForward();
                velocity.speed = 0;
            }
        }
        
        /**
         * Gets the sprite for the Cell, with the moving
         * indicator added.
         * @return
         */
        override public function getSprite():Sprite
        {
            var cellSprite:Sprite = super.getSprite();
            
            // Attach moving indicator
            if (!cellSprite.contains(_movedIndicator))
                cellSprite.addChild(_movedIndicator);
            
            return cellSprite;
        }
        
    }

}