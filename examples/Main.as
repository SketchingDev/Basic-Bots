package
{
    import com.flyingtophat.basicbot.Bot;
    import com.flyingtophat.basicbot.BotManager;
    import com.flyingtophat.basicbot.IBot;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Rectangle;
		
	/**
	 * @author <a href="http://flyingtophat.co.uk">Lucas</a>
	 */
	public class Main extends Sprite
	{
		public var botManager:BotManager;
		
		public function Main()
		{
			botManager = new BotManager(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			drawSquaredBackground(15);
			
			// Add bots to centre of the stage
			var bot:Bot;
			for (var i:uint = 0; i < BotManager.TOTAL_BOTS; i++)
			{
				bot = new DispersalBot();
				botManager.botCollection[i] = Bot(bot);
				stage.addChild(bot.getSprite());
				
				bot.x = (stage.stageWidth / 2);
				bot.y = (stage.stageHeight / 2);
			}
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		/**
		 * @param	squareSize	Width/Height of each square
		 */
		private function drawSquaredBackground(squareSize:uint):void
		{
			this.graphics.lineStyle(1, 0x000000, 0.1);
			
			var i:uint = 0;
			while ((i <= stage.stageHeight) || (i <= stage.stageWidth))
			{
				// Y axis
				this.graphics.moveTo(stage.stageWidth, i);
				this.graphics.lineTo(0, i);
				
				// X axis
				this.graphics.moveTo(i, 0);
				this.graphics.lineTo(i, stage.stageHeight);
				
				i += squareSize;
			}
		}
		
		/** Updates the cells */
		public function onEnterFrame(event:Event):void
		{
			botManager.progressBots();
		}
		
		/** Used by onClick to iterate through bot collection */
		private var _indexCounter:uint = 0;
		
		/**
		 * Places a cell at the mouse's position on the stage
		 */
		public function onClick(event:MouseEvent):void
		{
			var bot:IBot = botManager.botCollection[_indexCounter];
			bot.x = event.stageX;
			bot.y = event.stageY;
			
			_indexCounter++
			if (_indexCounter >= BotManager.TOTAL_BOTS) _indexCounter = 0;
		}
		
	}
	
}