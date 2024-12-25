using System;
using System.Data;
using Oracle.DataAccess.Client;

namespace Zadatak
{
    class Program
    {
        static void Main(string[] args)
        {
            string conString = "Data Source=160.99.9.63/gislab.ni.ac.rs;User Id=S18586;Password=S18586;";
            OracleConnection con = null;

            try
            {
                // Kreiranje i otvaranje konekcije
                con = new OracleConnection(conString);
                con.Open();

                // SQL upit
                string strSQL = @"
                    SELECT ZAPOSLENI.IME, ZAPOSLENI.PREZIME, ZAPOSLENI.PLATA
                    FROM ZAPOSLENI
                    INNER JOIN ISTORIJA_RADNIH_MESTA ON ZAPOSLENI.ID = ISTORIJA_RADNIH_MESTA.ID_ZAP
                    INNER JOIN ODELJENJE ON ISTORIJA_RADNIH_MESTA.ID_ODELJ = ODELJENJE.ID
                    WHERE ODELJENJE.NAZIV = :nazivOdeljenja
                    GROUP BY ZAPOSLENI.IME, ZAPOSLENI.PREZIME, ZAPOSLENI.PLATA
                    HAVING SUM(ISTORIJA_RADNIH_MESTA.DATUM_KRAJA - ISTORIJA_RADNIH_MESTA.DATUM_POC) > 100";

                // Unos parametra
                Console.WriteLine("Unesite naziv odeljenja:");
                string nazivOdeljenja = Console.ReadLine();

                // Kreiranje adaptera i dodavanje parametra
                OracleDataAdapter da = new OracleDataAdapter(strSQL, con);
                da.SelectCommand.Parameters.Add(new OracleParameter(":nazivOdeljenja", nazivOdeljenja));

                // Punjenje DataSet-a
                DataSet ds = new DataSet();
                da.Fill(ds, "Rezultat");

                // Ispis rezultata
                foreach (DataRow row in ds.Tables["Rezultat"].Rows)
                {
                    string ime = row["IME"].ToString();
                    string prezime = row["PREZIME"].ToString();
                    string plata = row["PLATA"].ToString();

                    Console.WriteLine($"Ime: {ime}, Prezime: {prezime}, Plata: {plata}");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Došlo je do greške: " + ex.Message);
            }
            finally
            {
                // Zatvaranje konekcije
                if (con != null && con.State == ConnectionState.Open)
                {
                    con.Close();
                }
            }
        }
    }
}
