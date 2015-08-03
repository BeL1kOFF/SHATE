namespace UnfoldingOfGoods.Logic
{
    public class ClassFactory
    {

        private DataLogic FDataLogic = null;
        private DataCommunication FDataCommunication = null;
        private LogicClass FLogicClass = null;

        private static ClassFactory FClassFactory = null;

        private static ClassFactory CreateInstance()
        {
            if (FClassFactory == null)
            {
                FClassFactory = new ClassFactory();
                FClassFactory.FDataLogic = new DataLogic();
                FClassFactory.FDataCommunication = new DataCommunication();
                FClassFactory.FLogicClass = new LogicClass();
            }
            return FClassFactory;
        }

        public static DataLogic DataBase
        {
            get { return CreateInstance().FDataLogic; }
        }

        public static DataCommunication Tcp
        {
            get { return CreateInstance().FDataCommunication; }
        }

        public static LogicClass Logic
        {
            get { return CreateInstance().FLogicClass; }
        }

    }
}