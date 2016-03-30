////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.process {

	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	[ExcludeClass]
	/**
	 * @private
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 11.4
	 * @langversion				3.0
	 * @created					25.03.2016 15:52:46
	 */
	internal final class Process$Concurrent implements Process$ {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		internal static const instance:Process$Concurrent = new Process$Concurrent();
		
		/**
		 * @private
		 */
		private static var _WORKER:Worker$;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Constructor
		 */
		public function Process$Concurrent() {
			if ( !instance && Worker$.isSupported ) {
				super();
			} else {
				Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function process(className:String, methodName:String, arguments:Array, success:Function, fault:Function):void {
			
			if ( !_WORKER ) {
				
				[Embed( source="Worker$Background.swf", mimeType="application/octet-stream" )]
				const Worker$Background$SWF:Class;

				_WORKER = new Worker$(
					new Worker$Background$SWF() as ByteArray
				);
				
			}
			
			_WORKER.send(
				{ c: className, m: methodName, a: arguments },
				function(result:Object):void {
					if ( result.fault ) fault( result.fault );
					else if ( result.success ) success( result.success );
				}
			);
			
		}
		
	}

}