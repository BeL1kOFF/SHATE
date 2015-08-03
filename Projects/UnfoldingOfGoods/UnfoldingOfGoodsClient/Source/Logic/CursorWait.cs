using System;
using System.Windows.Forms;

namespace UnfoldingOfGoods.Logic
{
    public class CursorWait : IDisposable
    {

        private Cursor FOldCursor;

        protected CursorWait()
        {
            FOldCursor = Cursor.Current;
            Cursor.Current = Cursors.WaitCursor;
        }

        public void Dispose()
        {
            Cursor.Current = FOldCursor;
        }

        public static CursorWait CreateWaitCursor()
        {
            return (new CursorWait());
        }

    }
}