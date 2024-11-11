package util

const (
	USD = "USD"
	TWD = "TWD"
	CAD = "CAD"
)

func IsSupportedCurrency(currency string) bool {
	switch currency {
	case USD, TWD, CAD:
		return true
	}
	return false
}
