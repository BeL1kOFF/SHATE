using System;
using System.IO;
using System.Reflection;
using System.Windows.Forms;

namespace UnfoldingOfGoods
{
    class MyClass
    {

        static public string AppPath
        {
            get { return Path.GetDirectoryName(Assembly.GetExecutingAssembly().GetName().CodeBase); }
        }

        static public string ConnectionString
        {
            get { return String.Concat("DataSource = ", AppPath, @"\UnfoldingOfGoods.sdf"); }
        }

        static public void ShowError(String aMessage)
        {
            MessageBox.Show(aMessage, "Ошибка!", MessageBoxButtons.OK, MessageBoxIcon.Hand, MessageBoxDefaultButton.Button1);
        }

        static public Boolean ShowQuestion(String aMessage)
        {
            return MessageBox.Show(aMessage, "Вопрос", MessageBoxButtons.YesNo, MessageBoxIcon.Question, MessageBoxDefaultButton.Button2) == DialogResult.Yes;
        }

        static public DialogResult ShowQuestionCancel(String aMessage)
        {
            return MessageBox.Show(aMessage, "Вопрос", MessageBoxButtons.YesNoCancel, MessageBoxIcon.Question, MessageBoxDefaultButton.Button3);
        }

        static public void ShowWarning(String aMessage)
        {
            MessageBox.Show(aMessage, "Внимание!", MessageBoxButtons.OK, MessageBoxIcon.Exclamation, MessageBoxDefaultButton.Button1);
        }

    }
}