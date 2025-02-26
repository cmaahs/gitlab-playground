package cmd

import (
	"net"

	"github.com/dschanoeh/hover-ddns/hover"
	"github.com/sirupsen/logrus"
	"github.com/spf13/cobra"
	"github.com/spf13/viper"
)

// updateCmd represents the update command
var updateCmd = &cobra.Command{
	Use:   "update",
	Short: "Update DNS record(s)",
	Long: `EXAMPLE:
	> update-hover-dns --zone-name <zone> --record-name <record> --record-type A --record-value '<nn.nn.nn.nn>'
`,
	Run: func(cmd *cobra.Command, args []string) {
		zoneName, _ := cmd.Flags().GetString("zone-name")
		recordName, _ := cmd.Flags().GetString("record-name")
		recordType, _ := cmd.Flags().GetString("record-type")
		recordValue, _ := cmd.Flags().GetString("record-value")

		updateRecord(zoneName, recordName, recordType, recordValue, false)
	},
}

func updateRecord(zn, rn, rt, rv string, dryRun bool) {

	var auth *hover.HoverAuth
	var err error

	updateIP := net.ParseIP(rv)

	username := viper.GetString("username")
	password := viper.GetString("password")

	if !dryRun {
		// Attempt hover login when the first entry that requires updating is discovered
		if auth == nil {
			auth, err = hover.Login(username, password)
			if err != nil {
				logrus.Error("Could not log in: ", err)
				return
			}
			logrus.Debug("AuthCookie [" + auth.AuthCookie.Name + "]: " + auth.AuthCookie.Value)
			logrus.Debug("SessionCookie [" + auth.SessionCookie.Name + "]: " + auth.SessionCookie.Value)
		}

		if updateIP != nil {
			err := hover.Update(auth, zn, rn, updateIP, nil)
			if err != nil {
				logrus.Error("Was not able to update hover records: ", err)
				return
			}
		}
	}

}

func init() {
	rootCmd.AddCommand(updateCmd)
	updateCmd.Flags().StringP("zone-name", "z", "", "The DNS zone name")
	updateCmd.Flags().StringP("record-name", "r", "", "The DNS resource record name")
	updateCmd.Flags().StringP("record-type", "t", "A", "The DNS record type")
	updateCmd.Flags().StringP("record-value", "v", "", "The DNS record value")
}
