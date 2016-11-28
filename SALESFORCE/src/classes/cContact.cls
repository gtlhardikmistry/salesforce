public class cContact {
        public Contact con {
            get;
            set;
        }
        public Boolean selected {
            get;
            set;
        }
        public cContact(Contact c) {
            con = c;
            selected = false;
        }
    }