public class sfab_FabricatedSObjectId {
  private static Integer counter = 0;
  
  public static Id getFakeId( Schema.SObjectType sObjectType ) {
    String strCounter = String.valueOf( ++counter );
    String prefix = sObjectType.getDescribe().getKeyPrefix();
    return Id.valueOf( prefix + '0'.repeat( 12 - strCounter.length() ) + strCounter );
  }
  
  
  public static Id getFakeId( Type type ) {
    SObject obj = (SObject) type.newInstance();
    return getFakeId( obj.getSObjectType() );
  }
}