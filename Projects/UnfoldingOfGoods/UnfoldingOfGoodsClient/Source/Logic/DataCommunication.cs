using System;
using System.IO;
using System.Net.Sockets;
using System.Text;
using System.Threading;
using System.Xml;
using UnfoldingOfGoods.Logic.Xml.Message.Custom;
using UnfoldingOfGoods.Logic.Xml.Response.Custom;
using UnfoldingOfGoods.Service;

namespace UnfoldingOfGoods.Logic
{
    class EDataCommunication : Exception
    {

        public EDataCommunication(String aMessage)
            : base(aMessage)
        {
        }

    }

    public delegate CustomXmlResponse CreateInstanceCustomXmlResponse(String aXml);

    public class DataCommunication
    {

        private TcpClient FClientSocket = null;
        private NetworkStream FStream = null;
        private MemoryStream FMemStream = new MemoryStream(0);
        private ManualResetEvent FEvent = new ManualResetEvent(false);

        public DataCommunication()
        {
        }

        private void Connect()
        {
            FClientSocket = new TcpClient(XmlOptions.Options.Server, XmlOptions.Options.Port);
            FStream = FClientSocket.GetStream();            
        }

        private void SendMessage(String aMessage)
        {
            using (MemoryStream memStream = new MemoryStream(0))
            {
                Byte[] bytesMessage = Encoding.GetEncoding(1251).GetBytes(aMessage);
                memStream.SetLength(bytesMessage.Length + 4);
                memStream.Position = 0;
                memStream.Write(BitConverter.GetBytes(bytesMessage.Length), 0, 4);
                memStream.Write(bytesMessage, 0, bytesMessage.Length);
                FStream.Write(memStream.ToArray(), 0, (Int32)memStream.Length);
            }
        }

        private Int32 GetSizeFromStreamMessage(MemoryStream aStream)
        {
            if (aStream.Length >= 4)
            {
                Byte[] tmpSize = new Byte[4];
                aStream.Position = 0;
                aStream.Read(tmpSize, 0, 4);
                return BitConverter.ToInt32(tmpSize, 0);
            }
            else
            {
                return 0;
            }
        }

        private void ReadStreamAsync()
        {
            try
            {
                Int32 bytes = 0;
                Byte[] bytesReceived = new Byte[256];
                Int32 currentPos = 0;
                Int32 size = 0;
                do
                {
                    // Читаем данные из сокета
                    bytes = FStream.Read(bytesReceived, 0, bytesReceived.Length);
                    // Дописываем прочитанные данные в память
                    currentPos = (Int32)FMemStream.Length;
                    FMemStream.SetLength(FMemStream.Length + bytes);
                    FMemStream.Position = currentPos;
                    FMemStream.Write(bytesReceived, 0, bytes);
                    // Читаем 4 байта будущего размера сообщения
                    size = GetSizeFromStreamMessage(FMemStream);
                } //Читаем дальше пока есть данные в сокете или пока сообщение не дошло целиком
                while ((FStream.DataAvailable) || (((FMemStream.Length - 4) < size)) && (FMemStream.Length != 0));
            }
            catch // Пока глушим все исключения, чтобы не вызвать ThreadAbortException
            {
            }
            // Устанавливаем событие
            FEvent.Set();
        }

        private String ResponseMessage()
        {
            try
            {
                // Очищаем память и сбрасываем событие
                FMemStream.SetLength(0);
                FEvent.Reset();

                // Запускаем нить, в которой будем читать из сокета данные
                Thread t = new Thread(ReadStreamAsync);
                t.Start();

                // Ждем установку события с таймаутом
                Boolean eventSignal = FEvent.WaitOne(XmlOptions.Options.Timeout, false);

                // Если был таймаут события...
                if (!eventSignal)
                {
                    // ...то закрываем поток сокета...
                    FStream.Close();
                    // ...и ждем пока нить не просигналит нам о завершении
                    FEvent.WaitOne();
                    throw new EDataCommunication(DataCommunicationStrings.ErrorResponse);
                }
                else
                {

                    // Читаем 4 байта размера сообщения
                    Int32 size = GetSizeFromStreamMessage(FMemStream);
                    // Пропускаем 4 байта для чтения последующего сообщения
                    FMemStream.Position = 4;
                    // Читаем в буфер сообщение и преобразовываем в строку
                    Byte[] tmpBytes = new Byte[size];
                    FMemStream.Read(tmpBytes, 0, size);
                    return Encoding.GetEncoding(1251).GetString(tmpBytes, 0, tmpBytes.Length);
                }
            }
            catch (IOException)
            {
                throw new EDataCommunication(DataCommunicationStrings.ErrorResponse);
            }
        }

        private void Close()
        {
            FStream.Close();
            FClientSocket.Close(); 
        }

        private String RequestServer(String aMessage)
        {
            GC.Collect();
            String StrXMLResponse = "";
            if (ScannerProxy.ScannerAPI.IsWIFI())
            {
                String mes = String.Concat(DataCommunicationStrings.XmlHeader, "\r\n", aMessage);
                Connect();
                SendMessage(mes);
                StrXMLResponse = ResponseMessage();
                Close();
                GC.Collect();
            }
            else
            {
                throw new EDataCommunication(DataCommunicationStrings.ErrorWiFi);
            }
            return StrXMLResponse;
        }

        public CustomXmlResponse GetResponse(CustomXmlMessage aXmlMessage, CreateInstanceCustomXmlResponse aCreateInstance)
        {
            String StrXMLResponse = RequestServer(aXmlMessage.Xml);

            try
            {
                CustomXmlResponse response = aCreateInstance(StrXMLResponse);

                return response;
            }

            catch (XmlException)
            {
                throw new EDataCommunication(String.Format(DataCommunicationStrings.ErrorXMLResponse, aCreateInstance.Method.Name));
            }
        }

    }
}