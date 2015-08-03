using System;

namespace UnfoldingOfGoods.Logic
{
    public static class ExceptionStrings
    {

        public static String ErrorWsaETimedOut = "Время соединения истекло.";
        public static String ErrorWsaEConnRefused = "В соединении отказано.";
        public static String DatabaseFileIsNotFound = "Файл базы данных не найден.";

        public static String ItIsExpectedMessage = "Ожидается сообщение {0}. Получено сообщение {1}";
        public static String CallFailed = "Ошибка вызова {0}. Сообщение: {1}";
        public static String XmlResponseException = "{0}. Код ошибки: {1}";

        public static String EmployeeIsNotFound = "Сотрудник не найден";
        public static String LayoutJobsNotFound = "Заданий на раскладку не найдено";

    }
}