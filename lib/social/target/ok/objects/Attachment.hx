package social.target.ok.objects;

/**
 * Прикреплённые данные для медиатопика.  
 * Документация: https://apiok.ru/dev/methods/rest/mediatopic/mediatopic.post
 */
typedef Attachment =
{
    @:optional var additionalInfo:Dynamic;
    
    @:optional var caption:String;

    @:optional var challenge_id:String;

    @:optional var comments_xid:String;

    @:optional var decorator_id:String;

    @:optional var description:String;

    @:optional var disableComments:Bool;

    @:optional var href:String;

    @:optional var impression_id:String;

    @:optional var media:Array<Dynamic>;

    @:optional var memory_id:Float;

    @:optional var motivator_id:String;

    @:optional var motivator_variant:String;

    @:optional var name:String;

    @:optional var new_challenge:Dynamic;

    @:optional var onBehalfOfGroup:Bool;

    @:optional var place:Dynamic;

    @:optional var place_id:String;

    @:optional var propagate:Bool;

    @:optional var property:Array<Dynamic>;

    @:optional var publishAt:String;

    @:optional var publishAtMs:Float;

    @:optional var with_friends:Array<String>;
}