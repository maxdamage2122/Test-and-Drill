package tv.digitalretro.events
{
	import flash.events.Event;
	
	public class MessageBoxEvent extends Event
	{
		public static const MESSAGEBOX_ENTER:String		= 'messageBoxENTER';
		public static const MESSAGEBOX_OK:String 		= 'messageBoxOK';
		public static const MESSAGEBOX_CANCEL:String 	= 'messageBoxCANCEL';
		public static const MESSAGEBOX_YES:String 		= 'messageBoxYES';
		public static const MESSAGEBOX_NO:String 		= 'messageBoxNO';
		
		public var message:String;
	
		public function MessageBoxEvent(type:String, msg:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			if (type=='messageBoxENTER')
			{
				message=msg;
			}
		}
	}
}